using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using Cave;
using System;

public class UITime : MonoBehaviour {

    private Text _text;
    private float _timePassed = 0f;
    private RectTransform _rectTransform;

    // Use this for initialization
    void Start () {

        // Set Position
        //_rectTransform = GetComponent<RectTransform>();
        //_rectTransform.anchoredPosition = new Vector2(-100f, -30f);

        _text = GetComponent<Text>();
    }
	
	// Update is called once per frame
	void Update () {

        _timePassed += Time.deltaTime;

        float minutes = Mathf.Floor(_timePassed / 60);
        float seconds = Mathf.Floor(_timePassed % 60);

        _text.text = minutes.ToString("00") + ":" + seconds.ToString("00");

        if (Input.GetKeyDown(KeyCode.A))
        {
            Reset();
        }
    }

    public void Reset()
    {
        _timePassed = 0f;
    }
}
