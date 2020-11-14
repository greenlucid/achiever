/** 
 * This holds the logo. When cursor hovers above logo,
 * it renders "Put your money where your mouth is",
 * in a cool way. It goes back to normal when is not
 * hovered.
 * 
 * It also renders ETH balance when web3 loads it.
 * Before that promise resolves it shows ... ETH instead.
 */

const Header = () => (
  <div className="Header"> 
    <h1>Achiever</h1>
    <h2>Put your money where your mouth is</h2>
  </div>
)

export default Header;
