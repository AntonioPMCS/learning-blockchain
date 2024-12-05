const Header = () => {


  function handleClick() {
    alert("Connect button clicked!");
  }

  return (
    <div className = "my-header">
      <h1>I'm inside Header</h1> 
      <button onClick={handleClick}>Connect</button> 
    </div>
  )
}

export default Header
