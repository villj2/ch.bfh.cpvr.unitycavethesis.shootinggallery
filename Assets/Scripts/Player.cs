﻿using UnityEngine;
using System.Collections;

public class Player : MonoBehaviour {

    private GameObject _cameraContainer;
    private GameObject _rifleContainer;
    private GameObject _rifleRotator;

	// Use this for initialization
	void Start () {
        _cameraContainer = GameObject.Find("CameraContainer");
        _rifleContainer = GameObject.Find("RifleContainer");
        _rifleRotator = GameObject.Find("RifleRotator");
	}
	
	// Update is called once per frame
	void Update () {

        if (Input.GetKey(KeyCode.LeftArrow) || Input.GetKey(KeyCode.A))
        {
            //_cameraContainer.transform.Rotate(Vector3.up, 1);
            //_rifleContainer.transform.Rotate(Vector3.up, 1);
            //this.transform.Rotate(Vector3.up, 1);

            _rifleRotator.transform.Rotate(Vector3.up, 1);
        }

        if (Input.GetKey(KeyCode.RightArrow) || Input.GetKey(KeyCode.D))
        {
            //_cameraContainer.transform.Rotate(Vector3.up, -1);
            //_rifleContainer.transform.Rotate(Vector3.up, -1);
            //this.transform.Rotate(Vector3.up, -1);

            _rifleRotator.transform.Rotate(Vector3.up, -1);
        }
    }
}
