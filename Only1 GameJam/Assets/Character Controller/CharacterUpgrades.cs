using UnityEngine;

[CreateAssetMenu(fileName = "CharacterUpgrades", menuName = "Scriptable Objects/CharacterUpgrades")]
public class CharacterUpgrades : ScriptableObject
{

    #region
    // upgrades

    public bool doubleJumpUnlocked { get; protected set; } = false;
    public bool wallJumpUnlocked { get; protected set; } = false;
    public bool dashUnlocked { get; protected set; } = false;

    #endregion

    public void UnlockUpgrade(Upgrades upgrade)
    {

        switch ( upgrade )
        {
            case Upgrades.doubleJump:
                doubleJumpUnlocked = true;
                break;
            case Upgrades.wallJump:
                wallJumpUnlocked = true;
                break;
            case Upgrades.dash:
                dashUnlocked = true;
                break;
            default:
                break;
        }

    }

}

public enum Upgrades { 
    doubleJump,
    wallJump,
    dash

}
