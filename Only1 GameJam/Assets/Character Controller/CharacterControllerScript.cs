using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using System;

[RequireComponent(typeof(Rigidbody2D))]
[RequireComponent(typeof(PlayerInput))]
public class CharacterControllerScript : MonoBehaviour
{

    #region
    // serialized variables, or variables tied to a specific mechanic

    [Header("Movement")]
    [SerializeField] private float moveSpeed = 5f;
    float horizontalMovement = 0;    //Vector2 to store the movement

    [Header("Dashing")]
    [SerializeField] private float dashSpeed = 20f;
    [SerializeField] private float dashDuration = 0.1f;
    [SerializeField] private float dashCooldown = 0.1f;
    bool isDashing = false;
    [SerializeField] bool canDash = false;
    TrailRenderer trailRenderer;

    [Header("Jump")]
    [Tooltip("This will modify how high up the player jumps")]
    [SerializeField] private float jumpPower = 10f;
    [Tooltip("This modifies how quickly the player falls back down")]
    [SerializeField] private float fallMultiplier = 2.5f;
    [Tooltip("This will determine how many jumps the character is able to make without touching ground.")]
    [SerializeField] private int maxJumps = 1;
    [Tooltip("This tracks how many jumps are left.")]
    [SerializeField] private int jumpsRemaining = 0;
    private bool isJumping;

    [Header("WallMovement")]
    [SerializeField] private float wallSlideSpeed = 2;
    bool isWallSliding;

    [Header("Gravity")]
    [Tooltip("This specifies at what point in the descent the Fall Multiplier kicks in")]
    [SerializeField] private float minimumFallHeight = 6f;
    [Tooltip("This limits the time spent floating. Any time spent above this value has reduced hang time.")]
    [SerializeField] private float upperFallHeight = 10f;

    [Header("GroundCheck")]
    [SerializeField] private Transform groundCheckPos;
    [SerializeField] private Vector2 groundCheckSize = new Vector2(.5f, .5f);
    [SerializeField] private LayerMask groundLayer;
    private bool isGrounded;

    [Header("WallCheck")]
    [SerializeField] private Transform wallCheckPos;
    [SerializeField] private Vector2 wallCheckSize = new Vector2(.5f, .5f);
    [SerializeField] private LayerMask wallLayer;

    #endregion

    //reference to the rigidbody
    private Rigidbody2D _rigidbody2D;

    //Unity new Input system variables
    private PlayerInput playerControls;
    private InputAction move;
    private InputAction jump;
    private InputAction dash;

    [Space(20)] [Tooltip("Ensure this is the CharacterUpgrades Asset")]
    // scriptable object for the upgrades
    [SerializeField] private CharacterUpgrades upgrades;

    private bool isFacingRight = true;


    //Awake is called on scene load.
    //Sets the playerControls to the PlayerInput Actions list
    private void Awake()
    {

        playerControls = new PlayerInput();

    }

    //Enables the Input actions, and subscribes to attacking being performed
    private void OnEnable() 
    {
        move = playerControls.Player.Move;
        move.Enable();
        jump = playerControls.Player.Jump;
        jump.Enable();
        dash = playerControls.Player.Dash;
        dash.Enable();

    }

    //disbles the Input actions
    private void OnDisable() 
    {

        move.Disable();
        jump.Disable();
        dash.Disable();

    }

    // Start is called before the first frame update
    // Sets the rigidbody component
    void Start()
    {

        _rigidbody2D = GetComponent<Rigidbody2D>();

    }

    // Update is called once per frame
    void Update()
    {

        // updates if the upgrade has been unlocked
        if ( upgrades.doubleJumpUnlocked && maxJumps == 1 ) maxJumps = 2;
        if ( upgrades.dashUnlocked ) canDash = true;

    }

    // applies movement to the character based off the moveDirection Vector2
    // fixedupdate is called at a fixed framerate, so movement won't be affected by varying FPS
    private void FixedUpdate() 
    {

        if ( isDashing ) return;

        _rigidbody2D.linearVelocity = new Vector2(horizontalMovement * moveSpeed, _rigidbody2D.linearVelocity.y);

        Gravity();
        // refreshes number of jumps remaining
        GroundCheck();
        Flip();
        ProcessWallSlide();

    }

    #region
    /*
     *  Input actions region
     */

    // stores the movement direction and force
    // is public so the InputAction events system can see it
    public void Move(InputAction.CallbackContext context)
    {

        horizontalMovement = context.ReadValue<Vector2>().x;

    }

    // performs the jump action when called
    public void Jump(InputAction.CallbackContext context)
    {
        if ( isJumping ) isJumping = false;

        if ( context.performed && jumpsRemaining > 0 )
        {
            isJumping = true;
            jumpsRemaining--;
            _rigidbody2D.linearVelocity = new Vector2(_rigidbody2D.linearVelocity.x, jumpPower);

        }

    }

    // performs the dash action when called
    public void Dash(InputAction.CallbackContext context)
    {

        if ( context.performed && canDash)
        {

            StartCoroutine(DashCoroutine());

        }

    }

    private IEnumerator DashCoroutine()
    {

        canDash = false;
        isDashing = true;

        trailRenderer.emitting = true;
        float dashDirection = 0f;

        yield return 0f;

    }

    #endregion

    private void ProcessWallSlide()
    {

        if ( !isGrounded && WallCheck() && horizontalMovement != 0)
        {

            isWallSliding = true;
            _rigidbody2D.linearVelocity = new Vector2(_rigidbody2D.linearVelocity.x, Mathf.Max(_rigidbody2D.linearVelocity.y, -wallSlideSpeed)); //caps fall rate

        }
        else
        {

            isWallSliding = true;

        }
        
    }

    private void GroundCheck()
    {

        if(Physics2D.OverlapBox(groundCheckPos.position, groundCheckSize, 0, groundLayer) && !isJumping )
        {

            jumpsRemaining = maxJumps;
            isGrounded = true;

        }
        else
        {

            isGrounded = false;

        }
    }

    private bool WallCheck()
    {

        return Physics2D.OverlapBox(wallCheckPos.position, wallCheckSize, 0, wallLayer);

    }

    private void Flip()
    {

        if ( isFacingRight && horizontalMovement < 0 || !isFacingRight && horizontalMovement > 0 )
        {

            isFacingRight = !isFacingRight;
            Vector3 localScale = transform.localScale;
            localScale.x *= -1f;
            transform.localScale = localScale;

        }

    }

    private void Gravity()
    {

        // causes the character to fall faster than they jumped up.
        if ( _rigidbody2D.linearVelocity.y < minimumFallHeight )
        {

            _rigidbody2D.linearVelocity += Vector2.up * Physics2D.gravity.y * ( fallMultiplier - 1 ) * Time.fixedDeltaTime;

        }
        else if ( _rigidbody2D.linearVelocity.y > upperFallHeight )
        {

            _rigidbody2D.linearVelocity += Vector2.up * Physics2D.gravity.y * ( fallMultiplier / 2 - 1 ) * Time.fixedDeltaTime;

        }

    }

    private void OnDrawGizmosSelected()
    {
        // Ground Check visual
        Gizmos.color = Color.white;
        Gizmos.DrawWireCube(groundCheckPos.position, groundCheckSize);

        // wall check visual
        Gizmos.color = Color.blue;
        Gizmos.DrawWireCube(wallCheckPos.position, wallCheckSize);

    }

}
