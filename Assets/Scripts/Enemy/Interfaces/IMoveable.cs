using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public interface IMoveable
{
    Rigidbody RB { get; set; }
    
    void Move(Vector3 velocity);
}
