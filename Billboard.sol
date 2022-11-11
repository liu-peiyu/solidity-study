pragma solidity >=0.4.22 <0.7.0;

contract Billboard {

    struct App{
        string name;
        address owner;
        uint8[] stars;
        mapping(address => uint) starOf;
        uint totalStar;
    }

    App[] public apps;

    event Public(string indexed name, address indexed oldOwner, uint appId);
    event Star(address indexed user, uint indexed appId, uint8 num);

    function publish(string memory name) public {
        require(bytes(name).length>0, "name error");
        apps.push(App(name, msg.sender, new uint8[](1),0));
        emit Public(name, msg.sender, apps.length-1);
    }

    function star(uint appId, uint8 num) public {
        require(appId < apps.length, "appid length error");
        require(num<=5 && num >=1, "num error");
        require(apps[appId].starOf[msg.sender]==0, "appid error");
        App storage app = apps[appId];
        app.stars.push(num);
        app.totalStar += num;
        app.starOf[msg.sender] = app.stars.length -1;
        emit Star(msg.sender, appId, num);
    }

    function top() public view returns(uint[] memory topIds){
        topIds = new uint[](10);
        for(uint n=1; n < apps.length; n++){
            uint topLast = n < topIds.length ? n : topIds.length -1;
            if(n >= topIds.length && apps[n].totalStar <= apps[topIds[topLast]].totalStar){
                continue;
            }
            topIds[topLast] = n;
            for(uint i = topLast; i>0; i--){
                if(apps[topIds[i]].totalStar > apps[topIds[i-1]].totalStar){
                    uint tempAppId = topIds[i];
                    topIds[i] = topIds[i-1];
                    topIds[i-1] = tempAppId;
                }else{
                    continue;
                }
            }
        }
    }

}