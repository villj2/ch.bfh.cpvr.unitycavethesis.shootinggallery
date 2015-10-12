using UnityEngine;
using System.Collections;

public class Bullet : MonoBehaviour {

    public float Speed = 30f;

    private Rigidbody _rigidbody;

	// Use this for initialization
	void Start () {
        
	}
	
	// Update is called once per frame
	void Update () {
	
	}

    public void Init()
    {
        _rigidbody = GetComponent<Rigidbody>();
    }

    public void Shoot()
    {
        _rigidbody.velocity = transform.forward * Speed;
    }
}
