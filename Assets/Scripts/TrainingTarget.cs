using UnityEngine;
using System.Collections;

public class TrainingTarget : MonoBehaviour, IShootingTarget {

    public int[] RandomWaitUntilShow = new int[] { 1, 5 };
    public int[] RandomWaitUntilHide = new int[] { 2, 4 };

    private Animator _animator;
    private System.Random _random;
    private int _animBase;
    private Coroutine _coroutine;
    private AudioSource _audioSource;

    void Start () {
        _animator = GetComponent<Animator>();
        _random = new System.Random();
        _audioSource = GetComponent<AudioSource>();

        StartCoroutine(Show());
    }
	
	void Update () { }

    IEnumerator Show()
    {
        //Debug.Log("wait until show");

        yield return new WaitForSeconds(_random.Next(RandomWaitUntilShow[0], RandomWaitUntilShow[1]));

        // Select random target
        _animBase = 10 * _random.Next(1, 4);

        //Debug.Log("show animbase: " + animbase);

        _animator.SetInteger("AnimParam", _animBase);

        _coroutine = StartCoroutine(Hide());
    }

    IEnumerator Hide()
    {
        //Debug.Log("wait until hide");

        yield return new WaitForSeconds(_random.Next(RandomWaitUntilHide[0], RandomWaitUntilHide[1]));

        //Debug.Log("hide");

        _animator.SetInteger("AnimParam", _animBase + 1);

        _coroutine = StartCoroutine(Show());
    }

    public int Hit()
    {
        if(_animator.GetInteger("AnimParam") > 0 && _animator.GetInteger("AnimParam") % 10 == 0)
        {
            StopCoroutine(_coroutine);

            // TODO play audio
            _audioSource.Play();

            _animator.SetInteger("AnimParam", _animBase + 3);

            StartCoroutine(Show());

            return 33;
        }

        return 0;
    }
}
