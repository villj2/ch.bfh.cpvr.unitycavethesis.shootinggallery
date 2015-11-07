using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using Cave;
using System;

public class UITime : MonoBehaviour {

    private Text _text;

    private CaveMain _main;
    private RectTransform _rectTransform;

    // Use this for initialization
    void Start () {

        _main = GameObject.Find("Cave").GetComponent<CaveMain>();

        // Set Position
        _rectTransform = GetComponent<RectTransform>();
        _rectTransform.anchoredPosition = new Vector2(-100f, -30f);

        _text = GetComponent<Text>();
    }
	
	// Update is called once per frame
	void Update () {

        float minutes = Mathf.Floor(Time.time / 60);
        float seconds = Mathf.Floor(Time.time % 60);

        _text.text = minutes.ToString("00") + ":" + seconds.ToString("00");
	}
}
