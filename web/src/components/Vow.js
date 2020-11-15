/**
 * Vow is shown in two different states.
 * It can be in the preview state, in which case it only renders
 * status (as icon), bond, creationDay, zeroDay and ID in a single,
 * easy to scroll row.
 * 
 * Or it can be in the focused state, in which case it
 * will expand, and render a detailed view of the Vow.
 * When a Vow is focused, all Vow in Vows except focused will
 * lose a lot of saturation, this making it easier for
 * the user to see what is happening.
 * 
 * **** Post thoughts: After some thinking, it might be better if I make separate
 *       components for separate states of Vow? I'd rather not have to overengineer.
 * 
 * Detailed view means the following:
 * - Retain preview information in the row: No matter how much user scrolls down.
 *      --->  Clicking it defocuses Vow.
 *      --->  If user scrolls so down that focused Vow is out of the screen,
 *              it also defocuses Vow.
 * - Show title
 * - Show vowFile (if easily renderable), else put a clickable link to IPFS' file.
 * - If challenged but dispute is still Pending, just show Challenger's claim, counter
 *    and dispute boot date.
 * 
 * - Show dispute/s if existing. Per dispute:
 *    - Clickable link to dispute in arbitrator
 *    - Clickable link to ethscan challenge 
 *    - Show Challenger's claim.
 *    - Show evidence ordered by time, past first.
 *    - Show current ruling.
 *    - If appealeable for a side in current phase, show side and show button and give box for amount to pledge.
 * 
 * - If not currently disputed:
 *    - If Clean and has passed clear_period, give button to claim Achieve and cashout.
 *    - (Not prototype) If last ruling was Achieve and it passes clear_period since that date, give button to claim Achieve and cashout.
 *        ---> TODO for contract: figure out appeal math+logic so that previous failed challenges get some funds stockpiled in treasure.
 *    - If still on time for a potential Challenge, button that deploys challenge info,
 *        which means: serum (and partials [counter, appealCost]), and a confirm button
 *    
 * - Finally, if !paid, give a button for cashout.
 */

import React, {useState} from "React"

const Vow = ({vowEvent, achieverContract, web3js}) => {
  
  const dataFromVowEvent = (vowEvent) => (
    0 // I'm stuck
  )

  return (
  <div className="Vow">
    {/*TODO*/}
  </div>
)}

export default Vow;
