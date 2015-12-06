using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Cave;

public class Main : MonoBehaviour {

	public Texture2D Crosshair;

	// Use this for initialization
	void Start () {

        Vector2 crosshairPos = new Vector2 (65f, 65f);
        Cursor.SetCursor (Crosshair, crosshairPos, CursorMode.Auto);
    }
 }