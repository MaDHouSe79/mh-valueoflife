<p align="center">
    <img width="140" src="https://icons.iconarchive.com/icons/iconarchive/red-orb-alphabet/128/Letter-M-icon.png" />  
    <h1 align="center">Hi 👋, I'm MaDHouSe</h1>
    <h3 align="center">A passionate allround developer </h3>    
</p>

<p align="center">
  <a href="https://github.com/MaDHouSe79/mh-valueoflife/issues">
    <img src="https://img.shields.io/github/issues/MaDHouSe79/mh-valueoflife"/> 
  </a>
  <a href="https://github.com/MaDHouSe79/mh-valueoflife/watchers">
    <img src="https://img.shields.io/github/watchers/MaDHouSe79/mh-valueoflife"/> 
  </a> 
  <a href="https://github.com/MaDHouSe79/mh-valueoflife/network/members">
    <img src="https://img.shields.io/github/forks/MaDHouSe79/mh-valueoflife"/> 
  </a>  
  <a href="https://github.com/MaDHouSe79/mh-valueoflife/stargazers">
    <img src="https://img.shields.io/github/stars/MaDHouSe79/mh-valueoflife?color=white"/> 
  </a>
  <a href="https://github.com/MaDHouSe79/mh-valueoflife/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/MaDHouSe79/mh-valueoflife?color=black"/> 
  </a>      
</p>

# MH-ValueOfLife (only for whitelisted servers) (Die HARD RP)
- You have 3 live's, but when you hit 0 live's, the char will be deleted, cause it's dead and you have to create a new char.
- The value of life is an economic value used to quantify the benefit of avoiding a fatality.
- Admins can give and take lives, you can also reset all players lives, or you can buy as a player an extra live but this cost a lot of money.

# Dependencies:
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-multicharacter](https://github.com/qbcore-framework/qb-multicharacter)
- [qb-ambulancejob](https://github.com/qbcore-framework/qb-ambulancejob)

# Command
- `/mylives` To check your lives. (all players)
- `/givelive [id]` Give a live to a player ID (admin only)
- `/takelive [id]` Take a live from a player ID (admin only)
- `/resetlive [id]` Reset lives for a player ID (admin only)
- `/resetalllives` Reset all players lives to max.

# Installation
- Step 1: First stop your server.
- Step 2: Copy the directory `mh-valueoflife` to `resources/[mh]/`.
- Stap 3: Add `ensure [mh]` in `server.cfg` below `ensure [defaultmaps]`.
- Step 4: After you are all done, you must restart the server.

# Server.cfg example
```conf
ensure qb-core
ensure mh-valueoflife
ensure [qb]
ensure [standalone]
ensure [voice]
ensure [defaultmaps]
ensure [mh]
```

# Add Extra Code for qb-ambulancejob
- in `qb-ambulancejob/client/main.lua` around line 52
```lua
local function IsPlayerDead()
    return isDead
end
exports('IsPlayerDead', IsPlayerDead)
```

# Add Extra Code for qb-multicharacter
- in `qb-multicharacter/server/main.lua` around line 26
```lua
if GetResourceState("mh-valueoflife") ~= 'missing' then
    exports['mh-valueoflife']:ResetLives(src)
end
```

# LICENSE
[GPL LICENSE](./LICENSE)<br />
&copy; [MaDHouSe79](https://www.youtube.com/@MaDHouSe79)
