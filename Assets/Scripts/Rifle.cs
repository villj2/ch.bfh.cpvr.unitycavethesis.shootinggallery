using UnityEngine;
using System.Collections;

public class Rifle : MonoBehaviour {

    public float ShootDelay = 2f; // Seconds to wait after a shot is fired
    public GameObject RaycastSource;
    public Bullet Bullet;
    public GameObject BulletTarget;

	public int RotationMaxX = 30;
	public int RotationMaxY = 30;

    RaycastHit hit;

    private AudioSource _audioSource;
    private Animation _animation;
    private bool _recentlyShot = false;
	private Quaternion _rotInit;
    private GameObject _rifleCenter;

    private Camera _camLeft;
    private Camera _camFront;
    private Camera _camRight;
    private Camera _camBottom;

    // Use this for initialization
    void Start () {
        _audioSource = GetComponent<AudioSource>();
        _animation = GetComponent<Animation>();

		//_rotInit = transform.parent.rotation;

        _rifleCenter = GameObject.Find("RifleCenter");
        _camLeft = GameObject.Find("CameraLeft").GetComponent<Camera>();
        _camFront = GameObject.Find("CameraFront").GetComponent<Camera>();
        _camRight = GameObject.Find("CameraRight").GetComponent<Camera>();
        _camBottom = GameObject.Find("CameraBottom").GetComponent<Camera>();

        _animation.Stop();
    }
	
	// Update is called once per frame
	void Update () {

        if (Input.GetKey(KeyCode.Mouse0))
        {
            StartCoroutine(Shoot());
        }

        // Set Rifle Rotation
        //float CursorPosPercentX = (100f / Screen.width * Input.mousePosition.x - 50f) * 2;
        //float CursorPosPercentY = (100f / Screen.height * Input.mousePosition.y - 50f) * -2;
        //transform.parent.rotation = _rotInit;

        //transform.parent.Rotate (Vector3.up, RotationMaxX * CursorPosPercentX / 100f);
        //transform.parent.Rotate (Vector3.right, RotationMaxY * CursorPosPercentY / 100f);

        ////float ScreenTileWidth = Screen.width / 2;
        ////float ScreenTileHeight = Screen.height / 2;
        ////float CursorPosPercentX = (100f / Screen.width * Input.mousePosition.x - 50f) * 2;
        ////float CursorPosPercentY = (100f / ScreenTileHeight * Input.mousePosition.y - 50f) * -2;

        Vector3 posRifleOnCamLeft = _camLeft.WorldToScreenPoint(_rifleCenter.transform.position);
        Vector3 posRifleOnCamFront = _camFront.WorldToScreenPoint(_rifleCenter.transform.position);
        Vector3 posRifleOnCamRight = _camRight.WorldToScreenPoint(_rifleCenter.transform.position);
        Vector3 posRifleOnCamBottom = _camBottom.WorldToScreenPoint(_rifleCenter.transform.position);

        // TODO choose correct camera
        Debug.Log("camleft: " + posRifleOnCamLeft);
        Debug.Log("camfront: " + posRifleOnCamFront);
        Debug.Log("camright: " + posRifleOnCamRight);
        Debug.Log("cambottom: " + posRifleOnCamBottom);
        Debug.Log("---------");



        Vector3 posRifleOnCam = posRifleOnCamRight;


        float shiftX = 100f / 250f * (Input.mousePosition.x - posRifleOnCam.x);
        float shiftY = 100f / 200f * (posRifleOnCam.y - Input.mousePosition.y);
        float shiftXPercent = shiftX < 0 ? Mathf.Max(shiftX, -100) : Mathf.Min(shiftX, 100);
        float shiftYPercent = shiftY < 0 ? Mathf.Max(shiftY, -100) : Mathf.Min(shiftY, 100);
        float RotX = 30f / 100f * shiftXPercent;
        float RotY = 30f / 100f * shiftYPercent;
        
        Quaternion rot = Quaternion.Euler(RotY, RotX + _camRight.transform.rotation.eulerAngles.y, 0);

        transform.parent.rotation = rot;
    }

    IEnumerator Shoot()
    {
        if (!_recentlyShot)
        {
            _recentlyShot = true;

            _audioSource.Play();
            //_animation.Play("RifleShoot");

            // Shoot Bullet
            /*Bullet bulletClone = (Bullet)Instantiate(Bullet, BulletTarget.transform.position, BulletTarget.transform.rotation);
            bulletClone.Init();
            bulletClone.Shoot();*/

            // Raycast
            //var raycast = new Ray(Camera.main.transform.position, Camera.main.transform.forward);
			Ray raycast = Camera.main.ScreenPointToRay(Input.mousePosition);

			if(Physics.Raycast(raycast, out hit, 100))
			{
				if(hit.rigidbody != null && hit.rigidbody.gameObject.tag == "ShootingTarget")
				{
					// FIXME Falls nicht genau im Zentrum des Screens geschossen wird, stimmt die AddForce() Richtung nicht ganz. --> Richtung vom Gewehr nehmen.
					hit.rigidbody.AddForce(Camera.main.transform.forward * 1000);
				}
			}

            Debug.DrawRay(Camera.main.transform.position, Camera.main.transform.forward);

            yield return new WaitForSeconds(ShootDelay);

            //_animation.Rewind("RifleShoot");

            _recentlyShot = false;
        }
    }
}
