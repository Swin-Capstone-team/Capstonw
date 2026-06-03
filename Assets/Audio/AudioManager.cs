using UnityEngine;
using System.Collections;

public class AudioManager : MonoBehaviour
{
    [Header("Playlist")]
    [Tooltip("List of audio clips to play in order.")]
    public AudioClip[] musicTracks;

    [Header("Settings")]
    [Range(0f, 1f)] public float masterVolume = 0.5f;
    [Tooltip("Time in seconds it takes to transition from one track to the next.")]
    public float crossfadeDuration = 2f;

    private AudioSource sourceA;
    private AudioSource sourceB;
    private bool isUsingSourceA = true;
    private int currentTrackIndex = 0;
    private bool isTransitioning = false;

    private void Awake()
    {
        // Dynamically create two AudioSources to handle the crossfading smoothly
        sourceA = gameObject.AddComponent<AudioSource>();
        sourceB = gameObject.AddComponent<AudioSource>();
        
        // Configure sources for background music (2D sound, no looping on the source itself)
        sourceA.spatialBlend = 0f; 
        sourceB.spatialBlend = 0f;
        sourceA.playOnAwake = false;
        sourceB.playOnAwake = false;
    }

    private void Start()
    {
        // Begin playing the first track if we have any
        if (musicTracks != null && musicTracks.Length > 0)
        {
            sourceA.clip = musicTracks[0];
            sourceA.volume = masterVolume;
            sourceA.Play();
        }
    }

    private void Update()
    {
        if (musicTracks == null || musicTracks.Length == 0) return;

        AudioSource activeSource = isUsingSourceA ? sourceA : sourceB;

        // Check if we are near the end of the track to start crossfading
        if (activeSource.isPlaying && !isTransitioning)
        {
            float remainingTime = activeSource.clip.length - activeSource.time;
            if (remainingTime <= crossfadeDuration)
            {
                TransitionToNextTrack();
            }
        }
        else if (!activeSource.isPlaying && !isTransitioning)
        {
            // Safety fallback in case the track ends unexpectedly or is shorter than the crossfade
            TransitionToNextTrack();
        }
    }

    private void TransitionToNextTrack()
    {
        if (musicTracks.Length == 0) return;

        isTransitioning = true;
        
        // Move to the next track, and loop back to 0 if we hit the end of the array
        currentTrackIndex = (currentTrackIndex + 1) % musicTracks.Length;
        AudioClip nextClip = musicTracks[currentTrackIndex];

        // Determine which source is fading out and which is fading in
        AudioSource fadingOutSource = isUsingSourceA ? sourceA : sourceB;
        AudioSource fadingInSource = isUsingSourceA ? sourceB : sourceA;

        // Swap the active source marker
        isUsingSourceA = !isUsingSourceA;

        StartCoroutine(CrossfadeRoutine(fadingOutSource, fadingInSource, nextClip));
    }

    private IEnumerator CrossfadeRoutine(AudioSource fadingOut, AudioSource fadingIn, AudioClip nextClip)
    {
        fadingIn.clip = nextClip;
        fadingIn.volume = 0f;
        fadingIn.Play();

        float timer = 0f;

        while (timer < crossfadeDuration)
        {
            timer += Time.deltaTime;
            float t = timer / crossfadeDuration;
            
            // Fade in the new track
            fadingIn.volume = Mathf.Lerp(0f, masterVolume, t);
            
            // Fade out the old track if it hasn't finished
            if (fadingOut.isPlaying)
            {
                fadingOut.volume = Mathf.Lerp(masterVolume, 0f, t);
            }

            yield return null;
        }

        // Ensure final volumes are neatly locked
        fadingIn.volume = masterVolume;
        
        fadingOut.volume = 0f;
        fadingOut.Stop();

        isTransitioning = false;
    }
}
