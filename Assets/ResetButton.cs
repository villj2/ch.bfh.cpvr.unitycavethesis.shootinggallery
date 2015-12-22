using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class ResetButton : MonoBehaviour {

	// Use this for initialization
	void Start () {
    }

    public void ButtonPressed()
    {
        Debug.Log("Button Reset Pressed");

        GameObject.Find("UIPoints").GetComponent<UIPoints>().Reset();
        GameObject.Find("UITime").GetComponent<UITime>().Reset();
    }
}
