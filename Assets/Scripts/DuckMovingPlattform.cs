using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class DuckMovingPlattform : MonoBehaviour {

    public GameObject BlockerLeft;
    public GameObject BlockerRight;
    public GameObject DuckFront;
    public GameObject DuckBack;

    private List<GameObject> _ducksOnPlattform;

    // Use this for initialization
    void Start () {
        _ducksOnPlattform = new List<GameObject>();

        Duck duckFront = DuckFront.GetComponent<Duck>();
        duckFront.OnHit += OnHit;

        Duck duckBack = DuckBack.GetComponent<Duck>();
        duckBack.OnHit += OnHit;
    }
	
	// Update is called once per frame
	void Update () {

        foreach (var duck in _ducksOnPlattform)
        {
            duck.GetComponent<Duck>().Move();
        }
	}

    void OnHit(Duck duck, Vector3 initPos, Quaternion initRot)
    {
        duck.transform.position = initPos;
        duck.transform.rotation = initRot;
    }

    void OnCollisionEnter(Collision col)
    {
        // Check if already exists in list and add
        if (!_ducksOnPlattform.Any(x => x.gameObject.GetInstanceID() == col.gameObject.GetInstanceID()))
        {
            _ducksOnPlattform.Add(col.gameObject);
        }
    }

    void OnCollisionExit(Collision col)
    {
        // Check if exists in list and remove
        if (_ducksOnPlattform.Any(x => x.gameObject.GetInstanceID() == col.gameObject.GetInstanceID()))
        {
            _ducksOnPlattform.Remove(col.gameObject);
            col.gameObject.GetComponent<Duck>().Dispose();
        }
    }

    public static void DelegateMethod(string message)
    {
        System.Console.WriteLine(message);
    }
}
