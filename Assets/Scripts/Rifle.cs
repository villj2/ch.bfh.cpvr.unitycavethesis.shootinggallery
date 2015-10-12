using UnityEngine;
using System.Collections;

public class Rifle : MonoBehaviour {

    public float ShootDelay = 2.0f; // Seconds to wait after a shot is fired
    public GameObject RaycastSource;
    public Bullet Bullet;
    public GameObject BulletTarget;

    RaycastHit hit;

    private AudioSource _audioSource;
    private Animation _animation;
    private bool _recentlyShot = false;

	// Use this for initialization
	void Start () {
        _audioSource = GetComponent<AudioSource>();
        _animation = GetComponent<Animation>();

        _animation.Stop();
    }
	
	// Update is called once per frame
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

            // Shoot Bullet
            Bullet bulletClone = (Bullet)Instantiate(Bullet, BulletTarget.transform.position, BulletTarget.transform.rotation);
            bulletClone.Init();
            bulletClone.Shoot();

            // Raycast
            var raycast = new Ray(Camera.main.transform.position, Camera.main.transform.forward);

            if (Physics.Raycast(raycast, out hit, 100))
            {
                Debug.Log("hit");

                // TODO check if hit target is duck
                // TODO add particle effect in wood or ground is hit

                hit.rigidbody.AddForce(Camera.main.transform.forward * 1000);
            }

            Debug.DrawRay(Camera.main.transform.position, Camera.main.transform.forward);

            yield return new WaitForSeconds(ShootDelay);

            _animation.Rewind("RifleShoot");

            _recentlyShot = false;
        }
    }
}
