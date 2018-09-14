# A CS:GO MultiHack (ACSGOMH)

![Menu](https://i.imgur.com/GH7a2m0.png)

ACSGOMH is an external CS:GO hack written in Purebasic.

Creating it was a good way to learn more about memory manipulation and related areas.

It has a SignatureScanner, NetVar-Manager, an unused implementation of a BSP-Parser and other stuff.

Although only a few people use Purebasic and the main file is just less then 3000 lines of code,
some people might find this helpfull, because they can look up how certain features are implemented.
Even though they might not use the same language, the logic obviously stays the same.

It does not use shellcode-injection, but still has a pretty big variety of features, including but not limited to:

- WebRadar
- TS3Callout
- Aimbot
- Triggerbot
- SkinChanger
- PlayerGlow (Team-, Healthbased, Vulnerable)
- EntityGlow (Weapons, Bomb, Grenade, Chickens)
- Bunnyhop
- RankParser
- AntiFlash
- ChatSpam
- FovChanger
- FakeLag
- NoHands
- Android App/API (includes VibratorESP)

Some Features are buggy, because they can not easily be implemented in an external flawlessly (especially without shellcode).

If you get errors when compiling, you are probably using the demo version of purebasic, 
so you might want to look into https://github.com/pf3ff3rl3/ACSGOMH/issues/1.

(Although I would recommend you to not actually use ACSGOMH, but instead learn from it!)

----------------------------------

Although I did create an android app for it, I am not making it open-source because it just is not worth it, the app simply connects to
ACSGOMH on the port 815 and basically uses an API to toggle features/receive position data/decide when to vibrate.
