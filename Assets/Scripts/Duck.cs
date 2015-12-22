using UnityEngine;
using System.Collections;
using System;

public class Duck : MonoBehaviour, IShootingTarget
{
    public const int POINTS = 30;

    public bool AlreadyHit {
        get
        {
            return _alreadyHit;
        }
    }

    public delegate void DelegateKill(Duck duck, Vector3 initPos, Quaternion initRot);
    public event DelegateKill OnKill;

    public delegate void DelegateHit(int points);
    public static event DelegateHit OnHit;

    public static float GlobalDuckSpeed = 1f;

    private int _direction = 1;
    private float _speed;
    private Vector3 _initPos;
    private Quaternion _initRot;
    private AudioSource _audioSource;
    private bool _alreadyHit = false;

    // Use this for initialization
    void Start () {

        _speed = UnityEngine.Random.Range(0.1f, 1f);

        _audioSource = GetComponent<AudioSource>();

        _initPos = gameObject.transform.position;
        _initRot = gameObject.transform.rotation;
    }
	
	// Update is called once per frame
	void Update () {
	
	}

    public void Hit()
    {
        if (!_alreadyHit)
        {
            _alreadyHit = true;
            _speed = 0;

            OnHit(POINTS);

            _audioSource.Play();

            StartCoroutine(Kill());
        }
    }

    IEnumerator Kill()
    {
        yield return new WaitForSeconds(UnityEngine.Random.Range(4, 8));

        //Destroy(this.gameObject);
        OnKill(gameObject.GetComponent<Duck>(), _initPos, _initRot);

        Start();
        _alreadyHit = false;
    }

    public void Move()
    {
        transform.Translate(Vector3.down * _direction * Time.deltaTime * _speed);
        transform.Translate(Vector3.down * _direction * Time.deltaTime * GlobalDuckSpeed);
    }

    void OnTriggerEnter(Collider col)
    {
        if (!_alreadyHit)
        {
            if(col.gameObject.name == "BlockerLeft")
            {
                _speed = UnityEngine.Random.Range(0.1f, 1f);
                _direction *= -1;
            
            }
            else if(col.gameObject.name == "BlockerRight")
            {
                _speed = UnityEngine.Random.Range(0.1f, 1f);
                _direction *= -1;
            }
        }
    }
}
