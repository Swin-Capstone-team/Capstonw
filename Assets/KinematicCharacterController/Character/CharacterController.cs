using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using KinematicCharacterController;
using System;

public enum CharacterState
{
    Default,
}

public enum OrientationMethod
{
    TowardsCamera,
    TowardsMovement,
}

public struct PlayerCharacterInputs
{
    public float MoveAxisForward;
    public float MoveAxisRight;
    public Quaternion CameraRotation;
    public bool JumpDown;
    public bool CrouchDown;
    public bool CrouchUp;
    public bool IsSprinting;
}

public struct AICharacterInputs
{
    public Vector3 MoveVector;
    public Vector3 LookVector;
}

public enum BonusOrientationMethod
{
    None,
    TowardsGravity,
    TowardsGroundSlopeAndGravity,
}

public class CharacterController : MonoBehaviour, ICharacterController
{
    public KinematicCharacterMotor Motor;

        [Header("Sprinting")]
        public float SprintMultiplier = 1.5f;
        public float SprintAcceleration = 5f;

        [Header("Stable Movement")]
        public float MaxStableMoveSpeed = 10f;
        public float MaxCrouchMoveSpeed = 4f;
        public float StableMovementSharpness = 15f;
        public float OrientationSharpness = 10f;
        public OrientationMethod OrientationMethod = OrientationMethod.TowardsCamera;

        [Header("Air Movement")]
        public float MaxAirMoveSpeed = 15f;
        public float AirAccelerationSpeed = 15f;
        public float Drag = 0.1f;

        [Header("Jumping")]
        public bool AllowJumpingWhenSliding = false;
        public float JumpUpSpeed = 10f;
        public float JumpScalableForwardSpeed = 10f;
        public float JumpPreGroundingGraceTime = 0f;
        public float JumpPostGroundingGraceTime = 0.2f;

        [Header("Vaulting")]
        public bool EnableVaulting = true;
        public float MaxVaultHeight = 1.5f;
        public float VaultCheckForwardDistance = 0.6f;
        public float VaultSpeed = 4f;

        [Header("Sliding")]
        public bool EnableSliding = true;
        public float SlideEnterSpeedThreshold = 6f;
        public float SlideInitialBoost = 4f;
        public float MaxSlideSpeed = 22f;
        public float SlideSteerMultiplier = 5f;
        public float SlideGravityAcceleration = 1f;
        public float SlideFriction = 14f;
        [Range(0f, 1f)] public float WallSlideBrakeFriction = 0.8f;

        [Header("Bunny Hop Decay")]
        public float SlideJumpDecayMultiplier = 0.6f;
        public float SlideRechargeTime = 1.5f;

        [Header("Misc")]
        public List<Collider> IgnoredColliders = new List<Collider>();
        public BonusOrientationMethod BonusOrientationMethod = BonusOrientationMethod.None;
        public float BonusOrientationSharpness = 10f;
        public Vector3 Gravity = new Vector3(0, -30f, 0);
        public Transform MeshRoot;
        public Transform CameraFollowPoint;
        public float CrouchedCapsuleHeight = 1f;

        public CharacterState CurrentCharacterState { get; private set; }

        public bool IsCrouching => _isCrouching;
        public bool IsSprinting => _isSprinting;
        public bool IsSliding => _isSliding;
        public bool HasMoveInput => _moveInputVector.sqrMagnitude > 0.01f;

        private Collider[] _probedColliders = new Collider[8];
        private RaycastHit[] _probedHits = new RaycastHit[8];
        private Vector3 _moveInputVector;
        private Vector3 _lookInputVector;
        private bool _jumpRequested = false;
        private bool _jumpConsumed = false;
        private bool _jumpedThisFrame = false;
        private float _timeSinceJumpRequested = Mathf.Infinity;
        private float _timeSinceLastAbleToJump = 0f;
        private Vector3 _internalVelocityAdd = Vector3.zero;
        private bool _shouldBeCrouching = false;
        private bool _isCrouching = false;
        private bool _isSprinting = false;
        private float _currentSprintMultiplier = 1f;
        private bool _isSliding = false;

        private int _consecutiveSlideJumps = 0;
        private float _continuousSprintTimer = 0f;
        
        private Vector3 lastInnerNormal = Vector3.zero;
        private Vector3 lastOuterNormal = Vector3.zero;

        private void Awake()
        {
            // Handle initial state
            TransitionToState(CharacterState.Default);

            // Assign the characterController to the motor
            Motor.CharacterController = this;
        }

        /// <summary>
        /// Handles movement state transitions and enter/exit callbacks
        /// </summary>
        public void TransitionToState(CharacterState newState)
        {
            CharacterState tmpInitialState = CurrentCharacterState;
            OnStateExit(tmpInitialState, newState);
            CurrentCharacterState = newState;
            OnStateEnter(newState, tmpInitialState);
        }

        /// <summary>
        /// Event when entering a state
        /// </summary>
        public void OnStateEnter(CharacterState state, CharacterState fromState)
        {
            switch (state)
            {
                case CharacterState.Default:
                    {
                        break;
                    }
            }
        }

        /// <summary>
        /// Event when exiting a state
        /// </summary>
        public void OnStateExit(CharacterState state, CharacterState toState)
        {
            switch (state)
            {
                case CharacterState.Default:
                    {
                        break;
                    }
            }
        }

        /// <summary>
        /// This is called every frame by ExamplePlayer in order to tell the character what its inputs are
        /// </summary>
        public void SetInputs(ref PlayerCharacterInputs inputs)
        {
            // Clamp input
            Vector3 moveInputVector = Vector3.ClampMagnitude(new Vector3(inputs.MoveAxisRight, 0f, inputs.MoveAxisForward), 1f);

            // Calculate camera direction and rotation on the character plane
            Vector3 cameraPlanarDirection = Vector3.ProjectOnPlane(inputs.CameraRotation * Vector3.forward, Motor.CharacterUp).normalized;
            if (cameraPlanarDirection.sqrMagnitude == 0f)
            {
                cameraPlanarDirection = Vector3.ProjectOnPlane(inputs.CameraRotation * Vector3.up, Motor.CharacterUp).normalized;
            }
            Quaternion cameraPlanarRotation = Quaternion.LookRotation(cameraPlanarDirection, Motor.CharacterUp);

            switch (CurrentCharacterState)
            {
                case CharacterState.Default:
                    {
                        // Move and look inputs
                        _moveInputVector = cameraPlanarRotation * moveInputVector;

                        switch (OrientationMethod)
                        {
                            case OrientationMethod.TowardsCamera:
                                _lookInputVector = cameraPlanarDirection;
                                break;
                            case OrientationMethod.TowardsMovement:
                                _lookInputVector = _moveInputVector.normalized;
                                break;
                        }

                        // Jumping input
                        if (inputs.JumpDown)
                        {
                            _timeSinceJumpRequested = 0f;
                            _jumpRequested = true;
                        }

                        // Crouching input
                        if (inputs.CrouchDown)
                        {
                            _shouldBeCrouching = true;

                            if (!_isCrouching)
                            {
                                _isCrouching = true;
                                Motor.SetCapsuleDimensions(0.5f, CrouchedCapsuleHeight, CrouchedCapsuleHeight * 0.5f);
                            }
                        }
                        else if (inputs.CrouchUp)
                        {
                            _shouldBeCrouching = false;
                        }

                        // Sprinting input
                        _isSprinting = inputs.IsSprinting;

                        break;
                    }
            }
        }

        /// <summary>
        /// This is called every frame by the AI script in order to tell the character what its inputs are
        /// </summary>
        public void SetInputs(ref AICharacterInputs inputs)
        {
            _moveInputVector = inputs.MoveVector;
            _lookInputVector = inputs.LookVector;
        }

        private Quaternion _tmpTransientRot;

        /// <summary>
        /// (Called by KinematicCharacterMotor during its update cycle)
        /// This is called before the character begins its movement update
        /// </summary>
        public void BeforeCharacterUpdate(float deltaTime)
        {
        }

        /// <summary>
        /// (Called by KinematicCharacterMotor during its update cycle)
        /// This is where you tell your character what its rotation should be right now. 
        /// This is the ONLY place where you should set the character's rotation
        /// </summary>
        public void UpdateRotation(ref Quaternion currentRotation, float deltaTime)
        {
            switch (CurrentCharacterState)
            {
                case CharacterState.Default:
                    {
                        if (_lookInputVector.sqrMagnitude > 0f && OrientationSharpness > 0f)
                        {
                            // Smoothly interpolate from current to target look direction
                            Vector3 smoothedLookInputDirection = Vector3.Slerp(Motor.CharacterForward, _lookInputVector, 1 - Mathf.Exp(-OrientationSharpness * deltaTime)).normalized;

                            // Set the current rotation (which will be used by the KinematicCharacterMotor)
                            currentRotation = Quaternion.LookRotation(smoothedLookInputDirection, Motor.CharacterUp);
                        }

                        Vector3 currentUp = (currentRotation * Vector3.up);
                        if (BonusOrientationMethod == BonusOrientationMethod.TowardsGravity)
                        {
                            // Rotate from current up to invert gravity
                            Vector3 smoothedGravityDir = Vector3.Slerp(currentUp, -Gravity.normalized, 1 - Mathf.Exp(-BonusOrientationSharpness * deltaTime));
                            currentRotation = Quaternion.FromToRotation(currentUp, smoothedGravityDir) * currentRotation;
                        }
                        else if (BonusOrientationMethod == BonusOrientationMethod.TowardsGroundSlopeAndGravity)
                        {
                            if (Motor.GroundingStatus.IsStableOnGround)
                            {
                                Vector3 initialCharacterBottomHemiCenter = Motor.TransientPosition + (currentUp * Motor.Capsule.radius);

                                Vector3 smoothedGroundNormal = Vector3.Slerp(Motor.CharacterUp, Motor.GroundingStatus.GroundNormal, 1 - Mathf.Exp(-BonusOrientationSharpness * deltaTime));
                                currentRotation = Quaternion.FromToRotation(currentUp, smoothedGroundNormal) * currentRotation;

                                // Move the position to create a rotation around the bottom hemi center instead of around the pivot
                                Motor.SetTransientPosition(initialCharacterBottomHemiCenter + (currentRotation * Vector3.down * Motor.Capsule.radius));
                            }
                            else
                            {
                                Vector3 smoothedGravityDir = Vector3.Slerp(currentUp, -Gravity.normalized, 1 - Mathf.Exp(-BonusOrientationSharpness * deltaTime));
                                currentRotation = Quaternion.FromToRotation(currentUp, smoothedGravityDir) * currentRotation;
                            }
                        }
                        else
                        {
                            Vector3 smoothedGravityDir = Vector3.Slerp(currentUp, Vector3.up, 1 - Mathf.Exp(-BonusOrientationSharpness * deltaTime));
                            currentRotation = Quaternion.FromToRotation(currentUp, smoothedGravityDir) * currentRotation;
                        }
                        break;
                    }
            }
        }

        /// <summary>
        /// (Called by KinematicCharacterMotor during its update cycle)
        /// This is where you tell your character what its velocity should be right now. 
        /// This is the ONLY place where you can set the character's velocity
        /// </summary>
        public void UpdateVelocity(ref Vector3 currentVelocity, float deltaTime)
        {
            switch (CurrentCharacterState)
            {
                case CharacterState.Default:
                    {
                        // Handle Sprint recharge logic
                        if (_isSprinting && Motor.GroundingStatus.IsStableOnGround && !_isSliding)
                        {
                            _continuousSprintTimer += deltaTime;
                            if (_continuousSprintTimer >= SlideRechargeTime)
                            {
                                _consecutiveSlideJumps = 0;
                            }
                        }
                        else
                        {
                            _continuousSprintTimer = 0f;
                        }

                        // Calculate smooth sprint multiplier transition
                        float targetSprintMultiplier = _isSprinting ? SprintMultiplier : 1f;
                        _currentSprintMultiplier = Mathf.MoveTowards(_currentSprintMultiplier, targetSprintMultiplier, SprintAcceleration * deltaTime);

                        // Ground movement
                        if (Motor.GroundingStatus.IsStableOnGround)
                        {
                            float currentVelocityMagnitude = currentVelocity.magnitude;

                            // === Sliding Entry / Exit Logic ===
                            if (EnableSliding && _shouldBeCrouching)
                            {
                                // Trigger slide if moving fast enough
                                if (!_isSliding && currentVelocityMagnitude >= SlideEnterSpeedThreshold)
                                {
                                    _isSliding = true;

                                    // Calculate decayed boost
                                    float currentBoost = SlideInitialBoost * Mathf.Pow(SlideJumpDecayMultiplier, _consecutiveSlideJumps);

                                    // Add immediate flat velocity boost in direction of movement
                                    if (currentVelocityMagnitude > 0f)
                                    {
                                        currentVelocity += currentVelocity.normalized * currentBoost;
                                        // Cap the speed right after boosting to prevent infinite speed scaling from bunny hopping
                                        currentVelocity = Vector3.ClampMagnitude(currentVelocity, MaxSlideSpeed);
                                        currentVelocityMagnitude = currentVelocity.magnitude; // update magnitude checks
                                    }
                                }
                            }
                            else
                            {
                                _isSliding = false;
                            }

                            // If we slow down too much during a slide, gracefully exit slide into normal crouch
                            if (_isSliding && currentVelocityMagnitude < SlideEnterSpeedThreshold - 1f)
                            {
                                _isSliding = false;
                            }

                            Vector3 effectiveGroundNormal = Motor.GroundingStatus.GroundNormal;

                            // Reorient velocity on slope
                            currentVelocity = Motor.GetDirectionTangentToSurface(currentVelocity, effectiveGroundNormal) * currentVelocityMagnitude;

                            if (_isSliding)
                            {
                                // 1. Downhill / Uphill Acceleration 
                                // Projecting gravity onto the ground plane perfectly aligns with the downslope vector.
                                // If running uphill, this vector naturally points backwards, automatically applying negative acceleration!
                                Vector3 downhillVector = Vector3.ProjectOnPlane(Gravity, effectiveGroundNormal);
                                currentVelocity += downhillVector * SlideGravityAcceleration * deltaTime;

                                // 2. Steerability (Accelerate in input direction without killing slide momentum)
                                if (_moveInputVector.sqrMagnitude > 0f)
                                {
                                    float preSteerMagnitude = currentVelocity.magnitude;

                                    Vector3 inputRight = Vector3.Cross(_moveInputVector, Motor.CharacterUp);
                                    Vector3 reorientedInput = Vector3.Cross(effectiveGroundNormal, inputRight).normalized * _moveInputVector.magnitude;
                                    
                                    currentVelocity += reorientedInput * SlideSteerMultiplier * deltaTime;

                                    // Prevent steering from adding free acceleration (only redirects momentum)
                                    if (currentVelocity.magnitude > preSteerMagnitude)
                                    {
                                        currentVelocity = currentVelocity.normalized * preSteerMagnitude;
                                    }
                                }

                                // 3. Friction
                                // Cleanly decelerate to exactly zero using MoveTowards instead of subtracting vectors 
                                currentVelocity = Vector3.MoveTowards(currentVelocity, Vector3.zero, SlideFriction * deltaTime);

                                // 4. Hard Cap Speed to prevent infinite acceleration loops
                                currentVelocity = Vector3.ClampMagnitude(currentVelocity, MaxSlideSpeed);
                            }
                            else
                            {
                                // Calculate target velocity
                                Vector3 inputRight = Vector3.Cross(_moveInputVector, Motor.CharacterUp);
                                Vector3 reorientedInput = Vector3.Cross(effectiveGroundNormal, inputRight).normalized * _moveInputVector.magnitude;
                                
                                float currentMaxSpeed = _shouldBeCrouching ? MaxCrouchMoveSpeed : (MaxStableMoveSpeed * _currentSprintMultiplier);

                                Vector3 targetMovementVelocity = reorientedInput * currentMaxSpeed;

                                // Smooth movement Velocity
                                currentVelocity = Vector3.Lerp(currentVelocity, targetMovementVelocity, 1f - Mathf.Exp(-StableMovementSharpness * deltaTime));
                            }
                        }
                        // Air movement
                        else
                        {
                            // Add move input
                            if (_moveInputVector.sqrMagnitude > 0f)
                            {
                                Vector3 addedVelocity = _moveInputVector * AirAccelerationSpeed * deltaTime;

                                Vector3 currentVelocityOnInputsPlane = Vector3.ProjectOnPlane(currentVelocity, Motor.CharacterUp);

                                float currentMaxAirSpeed = MaxAirMoveSpeed * _currentSprintMultiplier;

                                // Limit air velocity from inputs
                                if (currentVelocityOnInputsPlane.magnitude < currentMaxAirSpeed)
                                {
                                    // clamp addedVel to make total vel not exceed max vel on inputs plane
                                    Vector3 newTotal = Vector3.ClampMagnitude(currentVelocityOnInputsPlane + addedVelocity, currentMaxAirSpeed);
                                    addedVelocity = newTotal - currentVelocityOnInputsPlane;
                                }
                                else
                                {
                                    // Make sure added vel doesn't go in the direction of the already-exceeding velocity
                                    if (Vector3.Dot(currentVelocityOnInputsPlane, addedVelocity) > 0f)
                                    {
                                        addedVelocity = Vector3.ProjectOnPlane(addedVelocity, currentVelocityOnInputsPlane.normalized);
                                    }
                                }

                                // Prevent air-climbing sloped walls
                                if (Motor.GroundingStatus.FoundAnyGround)
                                {
                                    if (Vector3.Dot(currentVelocity + addedVelocity, addedVelocity) > 0f)
                                    {
                                        Vector3 perpenticularObstructionNormal = Vector3.Cross(Vector3.Cross(Motor.CharacterUp, Motor.GroundingStatus.GroundNormal), Motor.CharacterUp).normalized;
                                        addedVelocity = Vector3.ProjectOnPlane(addedVelocity, perpenticularObstructionNormal);
                                    }
                                }

                                // Apply added velocity
                                currentVelocity += addedVelocity;
                            }

                            // Gravity
                            currentVelocity += Gravity * deltaTime;

                            // === Wall Slide Friction ===
                            if (_shouldBeCrouching && Motor.GroundingStatus.FoundAnyGround && !Motor.GroundingStatus.IsStableOnGround)
                            {
                                // We are pressing crouch against a steep unstable wall.
                                Vector3 fallDirection = Gravity.normalized;
                                Vector3 fallVelocity = Vector3.Project(currentVelocity, fallDirection);
                                
                                if (Vector3.Dot(fallVelocity, fallDirection) > 0f) // Only brake if we are falling downwards
                                {
                                    // Physically brake the character's *current* fall speed down to a slow crawl (2 m/s)
                                    Vector3 targetFallVelocity = fallDirection * 2f; 
                                    if (fallVelocity.magnitude > targetFallVelocity.magnitude)
                                    {
                                        Vector3 newFallVelocity = Vector3.Lerp(fallVelocity, targetFallVelocity, WallSlideBrakeFriction * 10f * deltaTime);
                                        currentVelocity -= fallVelocity;     // Remove old fast fall
                                        currentVelocity += newFallVelocity;  // Inject slow, controlled fall
                                    }
                                }
                            }

                            // Drag
                            currentVelocity *= (1f / (1f + (Drag * deltaTime)));
                        }

                        // === Vaulting / Step Assistance ===
                        if (EnableVaulting && _moveInputVector.sqrMagnitude > 0f)
                        {
                            Vector3 shinHeight = Motor.TransientPosition + (Motor.CharacterUp * 0.2f);
                            
                            // 1. Raycast forward from shin height to detect if there's a wall or obstacle directly in our path
                            if (Physics.Raycast(shinHeight, _moveInputVector.normalized, out RaycastHit frontHit, VaultCheckForwardDistance, Motor.CollidableLayers, QueryTriggerInteraction.Ignore))
                            {
                                // 2. Obstacle detected! Now we raycast downwards just past the edge of the obstacle to find its flat top surface.
                                Vector3 topCheckStart = frontHit.point + (_moveInputVector.normalized * 0.1f) + (Motor.CharacterUp * MaxVaultHeight);
                                
                                if (Physics.Raycast(topCheckStart, -Motor.CharacterUp, out RaycastHit topHit, MaxVaultHeight, Motor.CollidableLayers, QueryTriggerInteraction.Ignore))
                                {
                                    // 3. Check how tall this obstacle is relative to the player's feet
                                    float obstacleHeight = Vector3.Dot(topHit.point - Motor.TransientPosition, Motor.CharacterUp);

                                    // 4. If the obstacle is a valid candidate for vaulting (not just flat ground and not a skyscraper)
                                    if (obstacleHeight > 0.1f && obstacleHeight <= MaxVaultHeight)
                                    {
                                        float currentVerticalSpeed = Vector3.Dot(currentVelocity, Motor.CharacterUp);
                                        if (currentVerticalSpeed < VaultSpeed)
                                        {
                                            currentVelocity -= Motor.CharacterUp * currentVerticalSpeed; // Cancel current vertical velocity
                                            currentVelocity += Motor.CharacterUp * VaultSpeed;           // Apply steady lifting speed
                                        }
                                    }
                                }
                            }
                        }

                        // Handle jumping
                        _jumpedThisFrame = false;
                        _timeSinceJumpRequested += deltaTime;

                        if (_jumpRequested)
                        {
                            // See if we actually are allowed to jump
                            if (!_jumpConsumed && ((AllowJumpingWhenSliding ? Motor.GroundingStatus.FoundAnyGround : Motor.GroundingStatus.IsStableOnGround) || _timeSinceLastAbleToJump <= JumpPostGroundingGraceTime))
                            {
                                // Calculate jump direction before ungrounding
                                Vector3 jumpDirection = Motor.CharacterUp;
                                if (Motor.GroundingStatus.FoundAnyGround && !Motor.GroundingStatus.IsStableOnGround)
                                {
                                    jumpDirection = Motor.GroundingStatus.GroundNormal;
                                }

                                // Makes the character skip ground probing/snapping on its next update. 
                                // If this line weren't here, the character would remain snapped to the ground when trying to jump. Try commenting this line out and see.
                                Motor.ForceUnground();

                                // Add to the return velocity and reset jump state
                                float currentJumpForwardSpeed = JumpScalableForwardSpeed * _currentSprintMultiplier;
                                currentVelocity += (jumpDirection * JumpUpSpeed) - Vector3.Project(currentVelocity, Motor.CharacterUp);
                                currentVelocity += (_moveInputVector * currentJumpForwardSpeed);
                                
                                // Gracefully exit slide when jumping so we must re-enter upon landing
                                if (_isSliding)
                                {
                                    _isSliding = false;
                                    _consecutiveSlideJumps++;
                                }

                                _jumpRequested = false;
                                _jumpConsumed = true;
                                _jumpedThisFrame = true;
                            }
                        }

                        // Take into account additive velocity
                        if (_internalVelocityAdd.sqrMagnitude > 0f)
                        {
                            currentVelocity += _internalVelocityAdd;
                            _internalVelocityAdd = Vector3.zero;
                        }
                        break;
                    }
            }
        }

        /// <summary>
        /// (Called by KinematicCharacterMotor during its update cycle)
        /// This is called after the character has finished its movement update
        /// </summary>
        public void AfterCharacterUpdate(float deltaTime)
        {
            switch (CurrentCharacterState)
            {
                case CharacterState.Default:
                    {
                        // Handle jump-related values
                        {
                            // Handle jumping pre-ground grace period
                            if (_jumpRequested && _timeSinceJumpRequested > JumpPreGroundingGraceTime)
                            {
                                _jumpRequested = false;
                            }

                            if (AllowJumpingWhenSliding ? Motor.GroundingStatus.FoundAnyGround : Motor.GroundingStatus.IsStableOnGround)
                            {
                                // If we're on a ground surface, reset jumping values
                                if (!_jumpedThisFrame)
                                {
                                    _jumpConsumed = false;
                                }
                                _timeSinceLastAbleToJump = 0f;
                            }
                            else
                            {
                                // Keep track of time since we were last able to jump (for grace period)
                                _timeSinceLastAbleToJump += deltaTime;
                            }
                        }

                        // Handle uncrouching
                        if (_isCrouching && !_shouldBeCrouching)
                        {
                            // Do an overlap test with the character's standing height to see if there are any obstructions
                            Motor.SetCapsuleDimensions(0.5f, 2f, 1f);
                            if (Motor.CharacterOverlap(
                                Motor.TransientPosition,
                                Motor.TransientRotation,
                                _probedColliders,
                                Motor.CollidableLayers,
                                QueryTriggerInteraction.Ignore) > 0)
                            {
                                // If obstructions, just stick to crouching dimensions
                                Motor.SetCapsuleDimensions(0.5f, CrouchedCapsuleHeight, CrouchedCapsuleHeight * 0.5f);
                            }
                            else
                            {
                                // If no obstructions, uncrouch
                                _isCrouching = false;
                            }
                        }
                        break;
                    }
            }
        }

        public void PostGroundingUpdate(float deltaTime)
        {
            // Handle landing and leaving ground
            if (Motor.GroundingStatus.IsStableOnGround && !Motor.LastGroundingStatus.IsStableOnGround)
            {
                OnLanded();
            }
            else if (!Motor.GroundingStatus.IsStableOnGround && Motor.LastGroundingStatus.IsStableOnGround)
            {
                OnLeaveStableGround();
            }
        }

        public bool IsColliderValidForCollisions(Collider coll)
        {
            if (IgnoredColliders.Count == 0)
            {
                return true;
            }

            if (IgnoredColliders.Contains(coll))
            {
                return false;
            }

            return true;
        }

        public void OnGroundHit(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, ref HitStabilityReport hitStabilityReport)
        {
        }

        public void OnMovementHit(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, ref HitStabilityReport hitStabilityReport)
        {
        }

        public void AddVelocity(Vector3 velocity)
        {
            switch (CurrentCharacterState)
            {
                case CharacterState.Default:
                    {
                        _internalVelocityAdd += velocity;
                        break;
                    }
            }
        }

        public void ProcessHitStabilityReport(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, Vector3 atCharacterPosition, Quaternion atCharacterRotation, ref HitStabilityReport hitStabilityReport)
        {
        }

        protected void OnLanded()
        {
        }

        protected void OnLeaveStableGround()
        {
        }

        public void OnDiscreteCollisionDetected(Collider hitCollider)
        {
        }
    }