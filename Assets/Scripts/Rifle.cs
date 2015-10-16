using UnityEngine;
using System.Collections;

public class Rifle : MonoBehaviour {

    public float ShootDelay = 2.0f; // Seconds to wait after a shot is fired
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

	// Use this for initialization
	void Start () {
        _audioSource = GetComponent<AudioSource>();
        _animation = GetComponent<Animation>();

		_rotInit = transform.parent.rotation;

        _animation.Stop();
    }
	
	// Update is called once per frame
	void Update () {

        if (Input.GetKey(KeyCode.Mouse0))
        {
            StartCoroutine(Shoot());
        }

		// Set Rifle Rotation
		float CursorPosPercentX = (100f / Screen.width * Input.mousePosition.x - 50f) * 2;
		float CursorPosPercentY = (100f / Screen.height * Input.mousePosition.y - 50f) * -2;

		transform.parent.rotation = _rotInit;

		transform.parent.Rotate (Vector3.up, RotationMaxX * CursorPosPercentX / 100f);
		transform.parent.Rotate (Vector3.right, RotationMaxY * CursorPosPercentY / 100f);
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
