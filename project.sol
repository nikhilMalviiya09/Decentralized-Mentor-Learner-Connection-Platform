// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MentorEarnings {
    
    struct User {
        uint id;
        string name;
        string role; // "learner" or "mentor"
        address userAddress;
        uint earnings; // Earnings for mentors
    }

    mapping(uint => User) public users;
    mapping(uint => uint) public mentorSessions; // Count of sessions held by mentors

    uint public userCount;

    event UserRegistered(uint userId, string name, string role);
    event SessionCompleted(uint mentorId, uint earnings);

    function registerUser(string memory _name, string memory _role) public {
        require(
            keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("learner")) || 
            keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("mentor")), 
            "Role must be either 'learner' or 'mentor'."
        );

        userCount++;
        users[userCount] = User(userCount, _name, _role, msg.sender, 0);
        
        emit UserRegistered(userCount, _name, _role);
    }

    function completeSession(uint _mentorId, uint _earnings) public {
        require(users[_mentorId].id == _mentorId, "Mentor must exist.");
        require(
            keccak256(abi.encodePacked(users[_mentorId].role)) == keccak256(abi.encodePacked("mentor")),
            "User is not a mentor."
        );

        users[_mentorId].earnings += _earnings;
        mentorSessions[_mentorId]++;
        
        emit SessionCompleted(_mentorId, _earnings);
    }

    function getUser(uint _userId) public view returns (User memory) {
        return users[_userId];
    }

    function getEarnings(uint _userId) public view returns (uint) {
        return users[_userId].earnings;
    }

    function getSessionCount(uint _mentorId) public view returns (uint) {
        return mentorSessions[_mentorId];
    }
}
