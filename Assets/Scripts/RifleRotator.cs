using UnityEngine;
using System.Collections;
using Cave;

public class RifleRotator : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {

        // Get relative rotation between eyes / wand
        var rotFromPlugin = Quaternion.Inverse(API.Instance.Eyes.transform.rotation) * API.Instance.Wand.transform.rotation;

        // Rotate RotatorEyes
        transform.parent.parent.localRotation = API.Instance.Eyes.transform.rotation;

        // Rotate RotatorWand
        transform.parent.localRotation = rotFromPlugin;
    }
}
