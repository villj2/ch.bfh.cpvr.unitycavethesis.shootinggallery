using UnityEngine;
using System.Collections;
using System;

public class Duck : MonoBehaviour, IShootingTarget
{
    public delegate void DelegateHit(Duck duck, Vector3 initPos, Quaternion initRot);
    public event DelegateHit OnHit;

    private int _direction = 1;
    private float _speed = 0.5f;
    private Vector3 _initPos;
    private Quaternion _initRot;

	// Use this for initialization
	void Start () {
        //_aufruf1 = new DelegateHit(DuckMovingPlattform.OnHit);

        _initPos = gameObject.transform.position;
        _initRot = gameObject.transform.rotation;
    }
	
	// Update is called once per frame
	void Update () {
	
	}

    public void Dispose()
    {
        StartCoroutine(Kill());
    }

    IEnumerator Kill()
    {
        // TODO random time
        yield return new WaitForSeconds(4);

        //Destroy(this.gameObject);
        OnHit(gameObject.GetComponent<Duck>(), _initPos, _initRot);
    }

    public void Move()
    {
        transform.Translate(Vector3.down * _direction * Time.deltaTime * _speed);
    }

    void OnTriggerEnter(Collider col)
    {
        if(col.gameObject.name == "BlockerLeft")
        {
            _direction *= -1;
        }
        else if(col.gameObject.name == "BlockerRight")
        {
            _direction *= -1;
        }
    }

    public int Hit()
    {
        Dispose();

        return 0;
    }
}
