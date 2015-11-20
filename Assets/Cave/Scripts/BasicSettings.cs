﻿using UnityEngine;
using System.Collections;

namespace Cave
{
    public class BasicSettings
    {

        [System.Serializable]
        public class BlockPositionAxis
        {
            public bool X;
            public bool Y;
            public bool Z;
        }

        [System.Serializable]
        public class BlockRotationAxisWand
        {
            public bool Yaw;
            public bool Pitch;
            public bool Roll;
        }

        [System.Serializable]
        public class BlockRotationAxisEyes
        {
            public bool Yaw;
            public bool Roll;
        }

        [System.Serializable]
        public class AxisSensivity
        {
            [Range(0.0f, 2.0f)]
            public float x = 1f;
            [Range(0.0f, 2.0f)]
            public float y = 1f;
            [Range(0.0f, 2.0f)]
            public float z = 1f;
        }
    }
}
