using UnityEngine;
using System.Collections;
using Cave;

public class Rifle : MonoBehaviour {

    public float ShootDelay = 2f; // Seconds to wait after a shot is fired
    public GameObject RaycastSource;
    public Bullet Bullet;
    public Transform WhiteSmoke;
    public Transform SmokeShoot;
    public Transform SmokeShootPosition;

    public int RotationMaxX = 30;
	public int RotationMaxY = 30;

    RaycastHit hit;

    private AudioSource _audioSource;
    private Animation _animation;
    private bool _recentlyShot = false;
    private CameraManager _cameraManager;
    
    void Start () {
        _audioSource = GetComponent<AudioSource>();
        _animation = GetComponent<Animation>();
        _cameraManager = GameObject.FindWithTag("CameraManager").GetComponent<CameraManager>();

        var cc = API.Instance.Cave.CameraContainer;

        _animation.Stop();
    }
	
	void Update () {

        if (Input.GetKey(KeyCode.Mouse0))
        {
            StartCoroutine(Shoot());
        }
    }

    IEnumerator Shoot()
    {
        if (!_recentlyShot)
        {
            _recentlyShot = true;

            _audioSource.Play();
            _animation.Play("RifleShoot");

            // SmokeShoot
            var smokeShoot = Instantiate(SmokeShoot, SmokeShootPosition.transform.position, SmokeShootPosition.transform.rotation);
            Destroy((smokeShoot as Transform).gameObject, 3);

            // Raycast
            //var raycast = new Ray(Camera.main.transform.position, Camera.main.transform.forward);
            //Ray raycast = Camera.main.ScreenPointToRay(Input.mousePosition);
            
            Debug.Log("Shoot with cam: " + _cameraManager.CameraWithCursor.name);
            Ray raycast = _cameraManager.CameraWithCursor.ScreenPointToRay(Input.mousePosition);

            if (Physics.Raycast(raycast, out hit, 100))
			{
                if (hit.rigidbody != null)
				{
                    // Duck
                    if(hit.rigidbody.gameObject.tag == "Duck" && !hit.rigidbody.gameObject.GetComponent<Duck>().AlreadyHit)
                    {
                        var hitPosition = hit.transform.position;
                        var camPosition = _cameraManager.CameraWithCursor.transform.position;
                        var vectToTarget = (hitPosition - camPosition);

                        hit.rigidbody.AddForce(vectToTarget.normalized * 1000);

                        // Note: no need to call hit. automatically called after leaving plattform.
                        //IShootingTarget duck = hit.collider.GetComponent<IShootingTarget>();
                        //duck.Hit();
                    }
                    // TrainingTarget
                    else if (hit.rigidbody.gameObject.tag == "TrainingTarget")
                    {
                        IShootingTarget target = hit.collider.transform.parent.parent.parent.parent.parent.GetComponent<IShootingTarget>();
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
