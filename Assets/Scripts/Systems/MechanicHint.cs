using System;
using UnityEngine;

[Serializable]
public class MechanicHint
{
    [Tooltip("Unique key that identifies the mechanic, e.g. 'Jump', 'Slide', 'Grapple'.\n" +
             "All hints sharing the same key are treated as one group — once any hint\n" +
             "from the group is shown, the whole group is considered seen for this run.")]
    public string mechanicKey = "";

    [Tooltip("The message displayed to the player, e.g. 'Press Space to jump'.")]
    [TextArea(1, 3)]
    public string message = "";
}
