Dear diary... today I...

Sorry, I was messing with you, but this is really going to be more of a blog than a development journal. *You've been warned.*

# Day 0

Before this, I had just developed this idea in my mind. The idea was to make a simple dapp to make promises. I got the idea around a month ago, when, as I enjoy doing occasionally, I wrote down my thoughts. *Making promises you can't keep is a good way to destroy your reputation.* Did I wrote that with me in mind? I think I was thinking more about scams, rugpulls and the like, and how important your reputation is as leverage. That's lost to time and memory. I thought it could be a fairly easy project that even I could make.

Fast forward, last weeks I've come to know how far away making this project could be, given that I'm running alone. I don't know the stack, I don't know Solidity, all I got is an idea I don't really know how to implement. Implementation was going to be harder than I expected, as it turns out that I kinda have to make everything from scratch myself, even features such as submitting evidence or appealing a dispute. So I tried to get some practice and learn the utmost basics of Solidity, web development and fooled around a bit and made some commits.

Day came, no cheating, no resources premade, nothing except a few notes. So when Hackathon began, namely when I woke up, I took some coffee, made some notes, took extra coffee, finished the diagram and I decided it just makes sense to keep this as a repo. So there I went:

- Short README.md
- Simple State Diagram

And then, I realized, how was I supposed to make the frontend if I didn't know the exact functioning of my own project yet? God bless cryptozombies, I managed not to suck too bad. I consulted this [Smart Contract Programmer](https://www.youtube.com/watch?v=4Mm3BCyHtDY) guy and learnt how to use Remix IDE in around one hour. God bless you too. 

I surprised myself and got really far. I'd say I only got to implement around 30% remaining (which really means, 90%, plus another 10% of bugs which will account for the remaining 90%), but still I had fun figuring all this stuff out. Did you know promise is a reserved word in Solidity? I refactored *promise* to *vow*, it also makes code less verbose. I opted not to commit the contract yet, I prefer doing that when it's holds all desired functionality, so that I can keep track on it in a more sane way. So, I'm real tired now. I figure it will be fun to try and predict what will I do tomorrow:

- Separate stuff in some more files for clarity (VowFactory.sol, stuff like that).
- Make an Arbitrator for some real raw testing.
- Figure out how to deploy all this stuff to a real testnet like Kovan.
- Spend cooldown time watching people in YouTube doing web3.js things.

I have no intention to make a pretty frontend, I don't even know if I will be able to make a functioning frontend, even. I wonder what will happen. It's exciting so far and I think I'll keep working on it even if I fail at finishing on time.

# Day 1

Dunning-Kruger effect did its job well. It appears I didn't even scratch the surface of the problem. Today I did some interesting progress two. I had to do a few difficult decisions, though:

- Kept code duplication. I should have stopped as soon as I noticed I was making dupe code. I should have not made "Achiever" and "Challenger". Still, I'm hacking, not developing, I can't, nor should do things the right way, so there I went copying and pasting functions and creating security hazards everywhere.
- Kept everything in Achiever.sol. Before, I thought my ~200 lines of code were a mess to keep in the same file, given that I had to make sure there were no bugs, everything should stay efficient, and all that. Now I have almost 400 lines of this alien language. And I'm making a PoC so screw that "tidying up" ill advice.

KlerosLiquid has appeal cost increment hardcoded at `2 * j + 1`, so my intentions to make it increment at around 30% per round are futile. I also won't have enough time to get the dispute states working as I'd wanted to. Originally I wanted the dispute to be ruled only depending on the Challenger's claim, but since the moment a Ruling is made the Vow will stay either Achieved or Failed, that is not feasible in this PoC. Otherwise, Achiever could simply challenge their own Vow with an invalid claim. So, in this PoC, jurors will rule in absolute terms, because this is the only shot. Also, everything KlerosLiquid related is so expensive so I will have to set up minimums for a few things.

In a future implementation, I'll make it so that even if disputes fail, disputes can still be made, and when a cooldown is set, Achiever can reclaim the bond. It would be interesting to see this in practice and compare the results. This can actually be done with current KlerosLiquid, but half of my contract would break if I made Vows able to be disputed multiple times, so this has to wait.

(Rambling) Current KlerosLiquid `_extraData` is so wasteful. 64 bytes just to indicate courtID and minimumJurors? Lol. If I was a computer then yeah, I could do that with less. Let's think. How many courts could KlerosLiquid possibly ever have? Let's go crazy and say 2^32, that's 4 bytes. Now, how many jurors? 2^64? So, everything fits in 32 bytes with tons of space to spare. Isn't 64 bytes too much? I just need two numbers for gods sake. This is what is sent and validated through the entire Ethereum blockchain every single time someone asks KlerosLiquid how much does it cost to do an initial arbitration (in HEX): `0x00000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003`

I don't think there'd be a lot of extra computation to have everything fit by half, it should save gas. Although, I expect Klerosv2 to have extra interactions with data in `_extraData`. Maybe remove `2 * j + 1` hardcode and allow for customization? Maybe even allow to choose between linear / expontential appeal cost growth? There are so many settings I'd like to try and see how they fare in practice.

I'd hope I was at least able to have the smart contract finished in time, but this is hard. And yet it's so interesting. I'm curious whether if I can do things directly in assembly to save gas. I should do some research on this. Not now, though. I wouldn't mind having this contracts riddled with bugs, and tomorrow no matter what, I'll have it compiled and deployed in Kovan because I need at least one full day to make the frontend, docs, Policy, a logo, and all that stuff. And I don't think I'll even be able to do that in a single day. So, for next day I'll finish appeal and appeal related stuff, which is the hardest part, and finally fill everything with Events. So far, my debugging attempts have been uncanningly unsuccessful, but there's no way I didn't mess up something.

Kleros team has been helpful as usual, props to them. This has been a free turbo bootcamp so far for me. Anyway, I'm tired and realistic, I don't think I'm actually going to finish this in time, but I might cheat a bit and simplify appeal logic in order to finish faster and get some frontend + extra work done tomorrow. Will see, seeya.
