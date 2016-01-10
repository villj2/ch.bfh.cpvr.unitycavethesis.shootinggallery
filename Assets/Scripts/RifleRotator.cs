using UnityEngine;
using System.Collections;
using Cave;

public class RifleRotator : MonoBehaviour {

	// Use this for initialization
	void Start () {

        //transform.parent.parent.parent = API.Instance.Cave.CameraContainer.transform;
        
        ////transform.parent.parent.parent = API.Instance.CameraContainer.transform;
        ////transform.parent.parent.localPosition = Vector3.zero;
    }
	
	// Update is called once per frame
	void Update () {

        //// Get relative rotation between eyes / wand
        ////var rotFromPlugin = Quaternion.Inverse(API.Instance.Cave.Eyes.transform.rotation) * API.Instance.Cave.Wand.transform.rotation;
        //var rotFromPlugin = API.Instance.AngleWandEyes;

        //// Rotate RotatorEyes
        //transform.parent.parent.localRotation = API.Instance.Eyes.transform.rotation;

        //// Rotate RotatorWand
        //transform.parent.localRotation = rotFromPlugin;

        transform.localPosition = API.Instance.Wand.transform.localPosition;
        transform.localRotation = API.Instance.Wand.transform.localRotation;
    }
}
