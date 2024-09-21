# MusicChain 🎶

MusicChain is a decentralized music player powered by blockchain. Artists can upload their music, and users can purchase, play, and rate songs. The project leverages smart contracts to handle payments, royalties, and song ownership, while using IPFS to store music files in a decentralized way.

## Features

- **Upload Songs**: Artists can upload songs with a price and royalty percentage.
- **Purchase and Play**: Users can purchase songs and play them while paying royalties to the artists.
- **Song Ratings**: After purchasing, users can rate songs from 1 to 5.
- **Decentralized Storage**: Music files are stored in IPFS, and only their hash is stored on-chain.

## Smart Contract Overview

The MusicChain smart contract handles:
- Song uploads with price and IPFS hash.
- Payment transfers when a song is purchased.
- Royalties for each playback.
- Song ratings to help users find top songs.

### Contract Methods

- `uploadSong(string title, uint256 price, string ipfsHash, uint256 royalty)`: Upload a new song with a title, price, and IPFS hash.
- `purchaseSong(uint256 songId)`: Purchase a song by its ID.
- `playSong(uint256 songId)`: Play a song and pay royalties to the artist.
- `rateSong(uint256 songId, uint256 rating)`: Rate a song you have purchased.

## How to Use

### Requirements

- [Node.js](https://nodejs.org/en/)
- [Hardhat](https://hardhat.org/)
- [MetaMask](https://metamask.io/) browser extension
- [IPFS](https://ipfs.io/)

### Setup

1. Clone the repository:
    ```bash
    git clone https://github.com/your-username/musicchain.git
    cd musicchain
    ```

2. Install dependencies:
    ```bash
    npm install
    ```

3. Compile the smart contract:
    ```bash
    npx hardhat compile
    ```

4. Deploy the contract to a test network (e.g., Rinkeby):
    ```bash
    npx hardhat run scripts/deploy.js --network rinkeby
    ```

5. Upload music files to IPFS:
    - Use a service like [Pinata](https://pinata.cloud/) to upload your music file and get the IPFS hash.

6. Interact with the smart contract:
    - Use the `uploadSong`, `purchaseSong`, `playSong`, and `rateSong` functions in the contract to upload, purchase, and interact with songs.

### License

This project is licensed under the MIT License.
