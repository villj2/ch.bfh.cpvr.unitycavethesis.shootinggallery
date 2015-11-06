using UnityEngine;
using System.Collections;
using Cave;

public class Rifle : MonoBehaviour {

    public float ShootDelay = 2f; // Seconds to wait after a shot is fired
    public GameObject RaycastSource;
    public Bullet Bullet;
    public Transform WhiteSmoke;

    public int RotationMaxX = 30;
	public int RotationMaxY = 30;

    RaycastHit hit;

    private AudioSource _audioSource;
    private Animation _animation;
    private bool _recentlyShot = false;

    private GameObject _rifleRotator;
    private Vector3 _rotOri;
    
    void Start () {
        _audioSource = GetComponent<AudioSource>();
        _animation = GetComponent<Animation>();

        _rifleRotator = GameObject.Find("RifleRotator");
        _rotOri = _rifleRotator.transform.rotation.eulerAngles;

        _animation.Stop();
    }
	
	void Update () {

        if (Input.GetKey(KeyCode.Mouse0))
        {
            StartCoroutine(Shoot());
        }

        // Get relative rotation between eyes / wand
        var rotFromPlugin = Quaternion.Inverse(CalculatedValues.Instance.Eyes.transform.rotation) * CalculatedValues.Instance.Wand.transform.rotation;
        //var rotFromPlugin = CalculatedValues.Instance.Eyes.transform.rotation * CalculatedValues.Instance.Wand.transform.rotation;

        //Debug.Log("rotFromPlugin: " + rotFromPlugin.eulerAngles);

        var q = Quaternion.FromToRotation(CalculatedValues.Instance.Eyes.transform.forward, CalculatedValues.Instance.Wand.transform.forward);
        rotFromPlugin = q * rotFromPlugin;

        // Add rotation from RifleRotator to y-axis of relative rotation between eyes / wand
        rotFromPlugin *= Quaternion.AngleAxis(_rifleRotator.transform.rotation.eulerAngles.y, Vector3.up);
        //rotFromPlugin *= _rifleRotator.transform.rotation;
        
        // FIXME wird die wand links oder rechts angeschaut, rotiert das gewehr bei einer wand/eyes-änderung auf einer falschen achse

        // TODO ignore rotation on z
        rotFromPlugin *= Quaternion.AngleAxis(0, Vector3.right);

        transform.parent.rotation = rotFromPlugin;
    }

    IEnumerator Shoot()
    {
        if (!_recentlyShot)
        {
            _recentlyShot = true;

            _audioSource.Play();
            //_animation.Play("RifleShoot");

            // Raycast
            //var raycast = new Ray(Camera.main.transform.position, Camera.main.transform.forward);
            //Ray raycast = Camera.main.ScreenPointToRay(Input.mousePosition);

            Debug.Log("Shoot with cam: " + CalculatedValues.Instance.CameraManager.CameraWithCursor.name);
            Ray raycast = CalculatedValues.Instance.CameraManager.CameraWithCursor.ScreenPointToRay(Input.mousePosition);

            if (Physics.Raycast(raycast, out hit, 100))
			{
                if (hit.rigidbody != null)
				{
                    // Duck
                    if(hit.rigidbody.gameObject.tag == "Duck")
                    {
                        var hitPosition = hit.transform.position;
                        var camPosition = CalculatedValues.Instance.CameraManager.CameraWithCursor.transform.position;
                        var vectToTarget = (hitPosition - camPosition);

                        hit.rigidbody.AddForce(vectToTarget.normalized * 1000);

                        //IShootingTarget duck = hit.collider.GetComponent<IShootingTarget>();
                        //duck.Hit();
                    }
                    // TrainingTarget
                    else if (hit.rigidbody.gameObject.tag == "TrainingTarget")
                    {
                        IShootingTarget target = hit.collider.transform.root.GetComponent<IShootingTarget>();
                        if (target != null)
                        {
                            target.Hit();
                        }
                    }
                }
                
                // Instantiate Particle Smoke
                var particleClone = Instantiate(WhiteSmoke, hit.point, Quaternion.LookRotation(hit.normal));
                Destroy((particleClone as Transform).gameObject, 3);
            }

            Debug.DrawRay(Camera.main.transform.position, Camera.main.transform.forward);

            yield return new WaitForSeconds(ShootDelay);

            //_animation.Rewind("RifleShoot");

            _recentlyShot = false;
        }
    }
}
