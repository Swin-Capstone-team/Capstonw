using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[System.Serializable]
public class SoundEffect
{
    public string id;
    public AudioClip[] audioClips;
}

public class AudioManager : MonoBehaviour
{
    public static AudioManager Instance { get; private set; }

    [Header("Playlist")]
    [Tooltip("List of audio clips to play in order.")]
    public AudioClip[] musicTracks;
    [SerializeField]
    private SoundEffect[] soundEffects;

    [Header("Settings")]
    [Range(0f, 1f)] public float masterVolume = 1f;
    [Range(0f, 1f)] public float musicVolume = 0.5f;
    [Range(0f, 1f)] public float sfxVolume = 1f;
    [Tooltip("Time in seconds it takes to transition from one track to the next.")]
    public float crossfadeDuration = 2f;

    private AudioSource sourceA;
    private AudioSource sourceB;
    private AudioSource sfxSource;
    private bool isUsingSourceA = true;
    private int currentTrackIndex = 0;
    private bool isTransitioning = false;
    private Dictionary<string, AudioClip[]> sfxLookup;
    

    private void Awake()
    {
        // Singleton pattern to ensure only one instance of AudioManager exists
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }

        Instance = this;

        // Dynamically create two AudioSources to handle the crossfading smoothly
        sourceA = gameObject.AddComponent<AudioSource>();
        sourceB = gameObject.AddComponent<AudioSource>();
        
        // Configure sources for background music (2D sound, no looping on the source itself)
        sourceA.spatialBlend = 0f; 
        sourceB.spatialBlend = 0f;
        sourceA.playOnAwake = false;
        sourceB.playOnAwake = false;

        // Sfx source and dictionary setup
        sfxSource = gameObject.AddComponent<AudioSource>();
        sfxSource.spatialBlend = 0f;
        sfxLookup = new Dictionary<string, AudioClip[]>();

        foreach (var sfx in soundEffects)
        {
            if (string.IsNullOrEmpty(sfx.id))
                continue;

            if (sfx.audioClips == null || sfx.audioClips.Length == 0)
                continue;

            if (!sfxLookup.ContainsKey(sfx.id))
            {
                sfxLookup.Add(sfx.id, sfx.audioClips);
            }
        }
    }

    private void Start()
    {
        // Begin playing the first track if we have any
        if (musicTracks != null && musicTracks.Length > 0)
        {
            sourceA.clip = musicTracks[0];
            sourceA.volume = GetMusicVolume();
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
            // Next track still plays while paused (crossfade is broken though)
            if (!fadingOut.isPlaying)
            {
                fadingIn.time = 0f;
                break;
            }
            timer += Time.deltaTime; //Affected by pause (timescale)
            float t = timer / crossfadeDuration;
            
            // Fade in the new track
            fadingIn.volume = Mathf.Lerp(0f, GetMusicVolume(), t);
            
            // Fade out the old track if it hasn't finished
            if (fadingOut.isPlaying)
            {
                fadingOut.volume = Mathf.Lerp(GetMusicVolume(), 0f, t);
            }

            yield return null;
        }

        // Ensure final volumes are neatly locked
        fadingIn.volume = GetMusicVolume();
        
        fadingOut.volume = 0f;
        fadingOut.Stop();

        isTransitioning = false;
    }



    private AudioClip GetRandomSFX(string id)
    {
        if (!sfxLookup.TryGetValue(id, out AudioClip[] clips))
            return null;

        if (clips.Length == 0)
            return null;

        return clips[Random.Range(0, clips.Length)];
    }

    public void PlaySFX(string id)
    {
        AudioClip clip = GetRandomSFX(id);

        if (clip != null)
        {
            sfxSource.PlayOneShot(clip, GetSFXVolume());
        }
    }

    public void PlaySFX(string id, float volume)
    {
        AudioClip clip = GetRandomSFX(id);

        if (clip != null)
        {
            sfxSource.PlayOneShot(clip, GetSFXVolume(volume));
        }
    }

    public void PlaySFX(string id, Vector3 position)
    {
        AudioClip clip = GetRandomSFX(id);

        if (clip != null)
        {
            AudioSource.PlayClipAtPoint(clip, position, GetSFXVolume());
        }
    }

    public void PlaySFX(string id, Vector3 position, float volume)
    {
        AudioClip clip = GetRandomSFX(id);

        if (clip != null)
        {
            AudioSource.PlayClipAtPoint(clip, position, GetSFXVolume(volume));
        }
    }


    private float GetMusicVolume()
    {
        return masterVolume * musicVolume;
    }


    private float GetSFXVolume(float volumeMultiplier = 1f)
    {
        return masterVolume * sfxVolume * volumeMultiplier;
    }

    public void UpdateMusicVolume()
    {
        AudioSource activeSource = isUsingSourceA ? sourceA : sourceB;
        activeSource.volume = GetMusicVolume();
    }
}
