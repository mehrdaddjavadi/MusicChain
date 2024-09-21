// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MusicPlayer {
    struct Song {
        string title;
        address artist;
        uint256 price;
        string ipfsHash;  // موزیک در IPFS ذخیره می‌شود
        uint256 royalty;  // درصد حق‌کپی‌رایت برای هر بار پخش
        uint256 rating;   // امتیاز موزیک
        uint256 voteCount;  // تعداد رای‌های ثبت شده
    }

    mapping(uint256 => Song) public songs;
    uint256 public songCount;

    mapping(uint256 => mapping(address => bool)) public songPurchased;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event SongUploaded(uint256 songId, string title, address artist, uint256 price, uint256 royalty);
    event SongPurchased(uint256 songId, address buyer);
    event SongPlayed(uint256 songId, address listener);
    event SongRated(uint256 songId, address voter, uint256 rating);

    // آپلود موزیک جدید
    function uploadSong(
        string memory _title,
        uint256 _price,
        string memory _ipfsHash,
        uint256 _royalty
    ) public {
        require(_price > 0, "Price must be greater than zero");
        require(_royalty >= 0 && _royalty <= 100, "Royalty must be between 0 and 100");

        songCount++;
        songs[songCount] = Song(_title, msg.sender, _price, _ipfsHash, _royalty, 0, 0);

        emit SongUploaded(songCount, _title, msg.sender, _price, _royalty);
    }

    // خرید موزیک
    function purchaseSong(uint256 _songId) public payable {
        Song memory song = songs[_songId];
        require(_songId > 0 && _songId <= songCount, "Song does not exist");
        require(msg.value >= song.price, "Not enough ether to purchase the song");
        require(!songPurchased[_songId][msg.sender], "Song already purchased");

        payable(song.artist).transfer(msg.value);
        songPurchased[_songId][msg.sender] = true;

        emit SongPurchased(_songId, msg.sender);
    }

    // پخش موزیک (و پرداخت حق‌کپی‌رایت)
    function playSong(uint256 _songId) public payable {
        Song memory song = songs[_songId];
        require(_songId > 0 && _songId <= songCount, "Song does not exist");
        require(songPurchased[_songId][msg.sender], "You have not purchased this song");

        uint256 royaltyAmount = (msg.value * song.royalty) / 100;
        payable(song.artist).transfer(royaltyAmount);

        emit SongPlayed(_songId, msg.sender);
    }

    // رای دادن به موزیک
    function rateSong(uint256 _songId, uint256 _rating) public {
        require(_songId > 0 && _songId <= songCount, "Song does not exist");
        require(songPurchased[_songId][msg.sender], "You must purchase the song to rate it");
        require(_rating >= 1 && _rating <= 5, "Rating must be between 1 and 5");
        require(!hasVoted[_songId][msg.sender], "You have already rated this song");

        Song storage song = songs[_songId];
        song.rating = ((song.rating * song.voteCount) + _rating) / (song.voteCount + 1);
        song.voteCount++;
        hasVoted[_songId][msg.sender] = true;

        emit SongRated(_songId, msg.sender, _rating);
    }

    // دریافت اطلاعات موزیک
    function getSong(uint256 _songId) public view returns (string memory title, address artist, string memory ipfsHash, uint256 rating) {
        require(_songId > 0 && _songId <= songCount, "Song does not exist");
        Song memory song = songs[_songId];
        return (song.title, song.artist, song.ipfsHash, song.rating);
    }
}
