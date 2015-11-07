using UnityEngine;
using System.Collections;

public class TrainingTarget : MonoBehaviour, IShootingTarget {

    public const int POINTS = 40;

    public int[] RandomWaitUntilShow = new int[] { 1, 5 };
    public int[] RandomWaitUntilHide = new int[] { 2, 4 };

    public delegate void DelegateHit(int points);
    public static event DelegateHit OnHit;

    private Animator _animator;
    private int _animBase;
    private Coroutine _coroutine;
    private AudioSource _audioSource;
    private int _idleState;

    void Start () {
        _animator = GetComponent<Animator>();
        _audioSource = GetComponent<AudioSource>();
        _idleState = Animator.StringToHash("Idle");

        StartCoroutine(Show());
    }
	
	void Update () { }

    IEnumerator Show()
    {
        //Debug.Log("wait until show");

        yield return new WaitForSeconds(Random.Range(RandomWaitUntilShow[0], RandomWaitUntilShow[1]));

        // Select random target
        _animBase = 10 * Random.Range(1, 3);

        //Debug.Log("show animbase: " + _animBase);

        _animator.SetInteger("AnimParam", _animBase);

        _coroutine = StartCoroutine(Hide());
    }

    IEnumerator Hide()
    {
        //Debug.Log("wait until hide");

        yield return new WaitForSeconds(Random.Range(RandomWaitUntilHide[0], RandomWaitUntilHide[1]));

        _animator.SetInteger("AnimParam", _animBase + 1);
        
        //Debug.Log("hide: " + _animBase);

        _coroutine = StartCoroutine(Show());
    }

    public void Hit()
    {
        int currentState = _animator.GetCurrentAnimatorStateInfo(0).tagHash;

        //if (_animator.GetInteger("AnimParam") > 0)
        if (currentState != _idleState)
        {
            StopCoroutine(_coroutine);
            
            OnHit(POINTS);

            _audioSource.Play();

            _animator.SetInteger("AnimParam", _animBase + 3);

            StartCoroutine(Show());
        }
    }
}
