using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using System;

[RequireComponent(typeof(Rigidbody2D))]
[RequireComponent(typeof(PlayerInput))]
public class CharacterControllerScript : MonoBehaviour
{
    //serialized values for editing in the console
    [SerializeField] private float moveSpeed = 5f;

    //reference to the rigidbody
    private Rigidbody2D _rigidbody2D;

    //Unity new Input system variables
    private PlayerInput playerControls;
    private InputAction move;

    //Vector2 to store the movement
    float horizontalMovement = 0;


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

    }

    //disbles the Input actions
    private void OnDisable() 
    {

        move.Disable();
//        attack.Disable();
    }

    // Start is called before the first frame update
    // Sets the rigidbody component
    void Start()
    {

        _rigidbody2D = GetComponent<Rigidbody2D>();

    }

    // Update is called once per frame
    //sets the movedirection
    void Update()
    {

        

    }

    //applies movement to the character based off the moveDirection Vector2
    private void FixedUpdate() 
    {

        _rigidbody2D.linearVelocity = new Vector2(horizontalMovement * moveSpeed, _rigidbody2D.linearVelocity.y);

    }

    public void Move(InputAction.CallbackContext context)
    {

        horizontalMovement = context.ReadValue<Vector2>().x;

    }

}
