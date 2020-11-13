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
