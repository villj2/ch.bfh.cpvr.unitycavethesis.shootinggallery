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
        var rotFromPlugin = Quaternion.Inverse(CalculatedValues.Instance.Eyes.transform.rotation) * CalculatedValues.Instance.Wand.transform.rotation;

        // Rotate RotatorEyes
        transform.parent.parent.localRotation = CalculatedValues.Instance.Eyes.transform.rotation;

        // Rotate RotatorWand
        transform.parent.localRotation = rotFromPlugin;
    }
}
