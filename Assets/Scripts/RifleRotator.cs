using UnityEngine;
using System.Collections;
using Cave;

public class RifleRotator : MonoBehaviour {

    Vector3 mouse_pos;
    Transform target; //Assign to the object you want to rotate
    Vector3 object_pos;
    float angle;

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

        //transform.localPosition = API.Instance.Wand.transform.localPosition;
        //transform.localRotation = API.Instance.Wand.transform.localRotation;
       

        //Get the Screen positions of the object
        //Vector2 positionOnScreen = Camera.main.WorldToViewportPoint(transform.position);

        //Get the Screen position of the mouse
        Vector2 mouseOnScreen = (Vector2)Camera.main.ScreenToViewportPoint(Input.mousePosition);
        

        //Get the angle between the points
        //float angle = AngleBetweenTwoPoints(positionOnScreen, mouseOnScreen);

        float angleVertical = ((mouseOnScreen.y - 0.5f) * 180f) * 0.5f;

        float angleHorizontal = ((mouseOnScreen.x - 0.5f) * 180f) * 0.5f;

        //Ta Daaa
        transform.localRotation = Quaternion.Euler(new Vector3(-angleVertical, angleHorizontal, 0f));
    }

    float AngleBetweenTwoPoints(Vector3 a, Vector3 b)
    {
        return Mathf.Atan2(a.y - b.y, a.x - b.x) * Mathf.Rad2Deg;
    }
}
