//SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract trazabilidadUP{

    address payable owner;

    struct role{
        uint cost; 
        string name;
        address roleAddress;
    }

    struct item {
        uint price; 
        string name;
        uint track;
    }

    mapping(uint => item) public items;
    mapping(uint => role) public roles;
    uint private counter = 0;
    uint private step = 0;
    

    constructor(){
        owner = payable(msg.sender);
    }

    modifier onlyOwner{
        require(msg.sender == owner, "Only owner can do this");
        _;
    }

    function addRole(uint _cost, string memory _name, address _roleAddress) public onlyOwner{
        roles[step] = role(_cost, _name, _roleAddress);
        step++;
    }

    function addItem(string memory _name) public onlyOwner{
        items[counter] = item(0, _name, 0);
        counter++;
    }

    function getItem(uint _index) public view returns(item memory){
        require(counter >= _index, "No existe el articulo");
        return items[_index];
    }

    function getRole(uint _step) public view returns(role memory){
        if(_step <= step){
            return roles[_step];
        } else{
            revert("El rol no existe");
        }
    }

    function getLastItem() public view returns(uint){
        return counter;
    }

    function aceptItem(uint _index) public view returns(bool){
        require(findItem(_index+1).roleAddress == msg.sender, "No tiene permiso para acceder a esta funcion");
        return true;
    } 

    function nextRole(uint _index) public {
        require(findItem(_index).roleAddress == msg.sender, "No tiene permiso para acceder a esta funcion");
        uint cost = findItem(_index).cost;
        items[_index].price += cost;
        if(aceptItem(_index)) items[_index].track++;
    }      

    function findItem(uint _index) public view returns(role memory){
        require(counter >= _index, "No existe el articulo");
        uint value = items[_index].track;
        return roles[value];
    }


    function getBalance() private view returns (uint256) {
        return address(this).balance;
    }


    function payForItem(uint _index) external payable onlyOwner {
        require(step == getItem(_index).track, "Aun no esta a la venta");
        for(uint i = 0; i <= step; i++){
            uint amount = roles[i].cost;
            address payable to = payable(roles[i].roleAddress);
            if(getBalance() >= amount){
                to.transfer(amount); 
            } else{
                revert("El balance es insuficiente");
            }
        }
    }

    function inject() external payable onlyOwner returns(uint256) {
    }

    function emergencyWithrow() external onlyOwner {

        uint256 amount = getBalance();
        owner.transfer(amount); 
    }

    function setOwner(address payable newOwner) external onlyOwner{
        owner = newOwner;
    }

    function destroy() external onlyOwner{
        selfdestruct(owner);
    }

}

/*

"Roles ejemplos"

2, "Proveedor", 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2

1, "Transporte", 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db

1, "Distribuidora", 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB

*/