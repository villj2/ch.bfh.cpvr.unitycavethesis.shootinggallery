using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class DuckSpeedSlider : MonoBehaviour {

    private Slider _slider;

	// Use this for initialization
	void Start () {
        _slider = GetComponent<Slider>();
        Duck.GlobalDuckSpeed = _slider.value;
    }
	
	// Update is called once per frame
	void Update () {

        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            _slider.value -= 0.1f;
            OnValueChanged();
        }

        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            _slider.value += 0.1f;
            OnValueChanged();
        }
    }

    public void OnValueChanged()
    {
        Duck.GlobalDuckSpeed = _slider.value;
    }
}
