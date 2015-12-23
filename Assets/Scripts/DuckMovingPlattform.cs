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

        if (DuckFront != null)
        {
            Duck duckFront = DuckFront.GetComponent<Duck>();
            duckFront.OnKill += OnKill;
        }

        if (DuckBack != null)
        {
            Duck duckBack = DuckBack.GetComponent<Duck>();
            duckBack.OnKill += OnKill;
        }
    }
	
	// Update is called once per frame
	void Update () {

        foreach (var duck in _ducksOnPlattform)
        {
            if(duck.tag == "Duck")
            {
                duck.GetComponent<Duck>().Move();
            }
        }
	}

    void OnKill(Duck duck, Vector3 initPos, Quaternion initRot)
    {
        duck.transform.position = initPos;
        duck.transform.rotation = initRot;

        _ducksOnPlattform.Remove(duck.gameObject);
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
            col.gameObject.GetComponent<Duck>().Hit();
        }
    }

    public static void DelegateMethod(string message)
    {
        System.Console.WriteLine(message);
    }
}
