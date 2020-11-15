/** 
 * This renders Vows. Vows is a list of Vow items.
 * In this state they are promises that will be loaded whenever node pleases.
 * They are loaded in preview status. When a Vow is focused, Vows will
 * set the previous focused Vow, if existing, to preview.
 * A loading gif appears at the end if there is still loading to do.
 * 
 */

import React, {useState} from "React"
import Vow from "./Vow"

const Vows = ({achieverContract, web3js}) => {
  
  const [vowList, setVowList] = useState([])

  const vowfy = (vowEvent) => (
    <Vow vowEvent={vowEvent} achieverContract={achieverContract} web3js={web3js}/>
  )

  return (
  <div className="Vows">
    {vowList.forEach(vowEvent => vowfy(vowEvent))}
  </div>
)}

export default Vows;
