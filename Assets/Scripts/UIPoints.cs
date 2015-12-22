using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System;
using Cave;

public class UIPoints : MonoBehaviour {

    private Text _text;
    private int _points;

    //private CaveMain _main;
    private RectTransform _rectTransform;

	// Use this for initialization
	void Start () {

        // Set Position
        //_rectTransform = GetComponent<RectTransform>();
        //_rectTransform.anchoredPosition = new Vector2(API.Instance.Cave.BeamerResolutionWidth + 20, -30f);

        _text = GetComponent<Text>();
        _points = 0;

        OnHit(_points);

        Duck.OnHit += OnHit;
        TrainingTarget.OnHit += OnHit;
	}

    void OnHit(int points)
    {
        _points += points;

        _text.text = "Punkte: " + _points.ToString();

        if (Input.GetKeyDown(KeyCode.A))
        {
            _points = 0;
        }
    }

    // Update is called once per frame
    void Update () {
	
	}
}
