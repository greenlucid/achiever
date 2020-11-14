/** 
 * Notes on style and philosophy:
 * This is supposed to be kind of minimalistic.
 * Having all main functionality in the same page
 * is a must. If extra stuff needs to be rendered,
 * just expand the page or show the info when hovering.
 * 
 * Uniswap is a reference on this kind of minimalism.
 * 
 * Never ever use window layers. They are the bane of my
 * existence and they bother everyone with good taste.
 * 
 * Let me specify main functionality:
 * - See list of Vows
 * - Create a Vow
 * - Challenge a Vow
 * - Read Vow details
 * - Read full Vow history and evidence
 * 
 * Things that it is better to keep separated:
 * - Docs, FAQ
 * - Policy
 * - Vow Blueprints
 * 
 * Things like being able to create shortcuts and the 
 * like will come later. This should do for now.
 */

import Header from "./Header"
import VowMakerButton from "./VowMaker"
import Vows from "./Vows"
import Footer from "./Footer"

const App = () => {
  return (
    <div className="App">
      <Header />
      <VowMakerButton />
      <Vows />
      <Footer />
    </div>
  );
}

export default App;
