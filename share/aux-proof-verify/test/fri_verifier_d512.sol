// SPDX-License-Identifier: MIT OR Apache-2.0
//---------------------------------------------------------------------------//
// Copyright (c) 2021 Mikhail Komarov <nemo@nil.foundation>
// Copyright (c) 2021 Ilias Khairullin <ilias@nil.foundation>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//---------------------------------------------------------------------------//

pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "truffle/Assert.sol";
import '../contracts/fri_verifier_adapted.sol';
import '../contracts/cryptography/transcript_updated.sol';

// TODO: add false-positive tests
contract TestFRIVerifier_d512 {
    function test_fri_proof_verification_d512() public {
        // bn254 scalar field
        uint256 modulus = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        bytes memory raw_proof = hex"00000000000000011cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e00000000000000092e19914a1fae0683757ade810e6ac03dae39522ef68fa15c8d3b3f77a277b97c000000000000002050adebba519a35eb21d69592e9e027e2655fbc6988cf480807213fa4cd8b08e800000000000000021afa7202096d3b3ee5ce6067d03a79122813f92c6cbaec3a7dd7db1dda810db3056e7681dd9f2f8a0d6dfd3161c4c3e1fdb8ea544827663fd96d9049f94bb2dd000000000000009100000000000000200b908e5de11cebe268c56059392d4c9d9f6fa307001830ed2b5c2aa62e68afd800000000000000080000000000000001000000000000000000000000000000205552318f9b6c7fc835be443c5bdf4c4ac9d90bf8a7b297dabfdd490d8fba95c80000000000000001000000000000000100000000000000209e4e5037ba5ca1629028fc5e8e92b0b8e376f52543cbbe80b6f4b861596d4e93000000000000000100000000000000010000000000000020d98462f85d19e00e52f547213661540a1d30318453661a3ddcf30267f4db31690000000000000001000000000000000100000000000000207e50ba10a2259912f72dc453eecd08c6e319cbcf14cb42b559348b3660140b3c0000000000000001000000000000000000000000000000202d938a737d26222f363b4cd7060de3fbf60136320c3ded114799b4960cbbbe5b000000000000000100000000000000010000000000000020b3dfe4d405ab06f813148619e1bcbd37639bf6f77c153fed1c4f357c09b6eac50000000000000001000000000000000100000000000000202a2d3b14c44ac8f7a416851b0ad3aafb5a6b9fe6024d00651c479d0227594bc8000000000000000100000000000000000000000000000020a6673c22f3f960b6f31959e46c55c5e2e3a85e94b6cea0440225a7d2e79f0c5d00000000000000020000000000000191000000000000002050adebba519a35eb21d69592e9e027e2655fbc6988cf480807213fa4cd8b08e80000000000000009000000000000000100000000000000000000000000000020c215b257dce8559b3cb758ed6ea764fd84c44501e0533cf57d41a55d5417936b0000000000000001000000000000000100000000000000203aa2750c7b3226ff7e120b7cb3d346bba7db4c99b8b7041f3ef9e0c302a5a36a00000000000000010000000000000001000000000000002035d460fa6d85f0bde1295cdbd22f584bd4394310558c564269e53219b018077900000000000000010000000000000001000000000000002079c6bde848be0be075e73b740aa67e9ea12e0fb3620964b04826ba5fb52cfb2a000000000000000100000000000000000000000000000020003d661e7f7ef889c4eb3f3da4c2131785daecff577f3966951d1c30e12eaa9a00000000000000010000000000000001000000000000002007041d328f4395a3acfc25e1a6d35e5fb953f1b73a3ec91f9b573abec3375e9b00000000000000010000000000000001000000000000002091a0d8a95a00ac2e057f78bb045435eb6d35dfca367b0941c76bc28cf3bd4cec00000000000000010000000000000000000000000000002001fb101581091ec793c3795774d537f0d5114ac93c62fd69518e97fac4e6c393000000000000000100000000000000000000000000000020cb9092723af98070126304ff21aaafdc7a5ffd3e5ff139a662ed35c2e86a28bd0000000000000091000000000000002050adebba519a35eb21d69592e9e027e2655fbc6988cf480807213fa4cd8b08e80000000000000009000000000000000100000000000000000000000000000020667762ecf13b6abb76f59546a031f6f0f92fa150b5707e635bbef0aa9f758121000000000000000100000000000000010000000000000020d42811caf4591a5a875f22a017b444cebe344e412393d7e83759af580eadaeac00000000000000010000000000000001000000000000002066aba63b5fad2bccff5b4fce6f001a695ff8ff40ca45a055f2c5891fa74c921300000000000000010000000000000001000000000000002096f5b6201edf2be58c64dd48fda154e203aad7196d028c15a401517710ca9f7500000000000000010000000000000000000000000000002073c1c973a0bfe11a94ae25a2cc81da35f4132cabaf1d3dd55bedd31d3dfef97f000000000000000100000000000000010000000000000020a5b40e1c51060f14c87e6690be10d6bfc5646720a91d3cca76f2aed7224df479000000000000000100000000000000010000000000000020e512ede9e068be615f6fbf66434f1b84f9e0f1b3bdaf7710ffa1e68ce62b0439000000000000000100000000000000000000000000000020375800259a670490c8a1bf198f745c5ea72db7d8d55c543630cf1cc8830f41ec000000000000000100000000000000010000000000000020839332a848615837578ca8cabd2c9cc3777e6f80318c8d164b123afd2823dc7520d26eb3b645dcea000ec12265cfbcce0a64f072892ae0f14b367c545c0f5d4500000000000000200b908e5de11cebe268c56059392d4c9d9f6fa307001830ed2b5c2aa62e68afd800000000000000022e19914a1fae0683757ade810e6ac03dae39522ef68fa15c8d3b3f77a277b97c05d8291f3cb8cdb57c23fd34bf765c5363c812e6d552b05d5835ea991973256300000000000000110000000000000020f57ba31d0ef1922aafc64459663ae2da1c528be215fee9d4dd13ab726beff698000000000000000700000000000000010000000000000000000000000000002032d0d9e307e8ebb61ec375cbaf24a412cae8977ee91ff86fde0a6b9633766aab0000000000000001000000000000000100000000000000204751322b32975e658ad633c08578c5668763459e7684a693a119badc642c19ca0000000000000001000000000000000100000000000000209f1e3f78389a6c70f16756eff0df8211cbd06250cd386124a66248743cb1f43e000000000000000100000000000000010000000000000020f0777a1c3967896213380307c6a40a48f726024ca53abbe88cc9ccb3c6c57ad10000000000000001000000000000000000000000000000203d5d0f244c232325d8723d297c283d8d29932f8fe43fee62e295a463c53b7ff9000000000000000100000000000000010000000000000020ed7ebd63ef842c0804c0d1447fba31b56e79a154ae966ca9cf6f86aeadff9963000000000000000100000000000000010000000000000020261f9bb561ad563bd0f1e5fc873f26b9c22a7cb8a0853446a11bcd6c82ce0cb90000000000000002000000000000009100000000000000200b908e5de11cebe268c56059392d4c9d9f6fa307001830ed2b5c2aa62e68afd800000000000000080000000000000001000000000000000000000000000000205552318f9b6c7fc835be443c5bdf4c4ac9d90bf8a7b297dabfdd490d8fba95c80000000000000001000000000000000100000000000000209e4e5037ba5ca1629028fc5e8e92b0b8e376f52543cbbe80b6f4b861596d4e93000000000000000100000000000000010000000000000020d98462f85d19e00e52f547213661540a1d30318453661a3ddcf30267f4db31690000000000000001000000000000000100000000000000207e50ba10a2259912f72dc453eecd08c6e319cbcf14cb42b559348b3660140b3c0000000000000001000000000000000000000000000000202d938a737d26222f363b4cd7060de3fbf60136320c3ded114799b4960cbbbe5b000000000000000100000000000000010000000000000020b3dfe4d405ab06f813148619e1bcbd37639bf6f77c153fed1c4f357c09b6eac50000000000000001000000000000000100000000000000202a2d3b14c44ac8f7a416851b0ad3aafb5a6b9fe6024d00651c479d0227594bc8000000000000000100000000000000000000000000000020a6673c22f3f960b6f31959e46c55c5e2e3a85e94b6cea0440225a7d2e79f0c5d000000000000001100000000000000200b908e5de11cebe268c56059392d4c9d9f6fa307001830ed2b5c2aa62e68afd80000000000000008000000000000000100000000000000000000000000000020d0fcbf05f2e6eff5df3a1b24a0c06e8a43a7a1e1b739ade99bd425b4b96b4fc6000000000000000100000000000000010000000000000020c0e97d887d29a7ad62e5b02bf5ad92ab3cfc7cb994f996daea4fe8ce29efd2e7000000000000000100000000000000010000000000000020c9cd81c30baa147f4e53004457460a23f40c18ede680d2d98e41c4f9c227f9be00000000000000010000000000000001000000000000002051bf87c643f416f7a36a209c652f394c6b77f165d713cda2151c4332598a3391000000000000000100000000000000000000000000000020007c8e57905c85eab98847d3d8aa69d3ae0a7e28d69edf03341c6c200de0745d000000000000000100000000000000010000000000000020db1a259fb01808257969e7376871fbb559b4d438a7ba65f0649a73a9197066fb000000000000000100000000000000010000000000000020b150c816684acc33d32ffa0ec5d6a02846102e9d8c44a4fc2fd900e1c63a2b9a00000000000000010000000000000001000000000000002007c6d94b174532b0a5c21a4c3c6223b868a24cccaf14a7e251386d03ba7258440530ba5bf91aef20f7861bc93bbfbf7106e8e97579ff4e72c3ea362876acccfa0000000000000020f57ba31d0ef1922aafc64459663ae2da1c528be215fee9d4dd13ab726beff698000000000000000220d26eb3b645dcea000ec12265cfbcce0a64f072892ae0f14b367c545c0f5d4517c81131561a341a5201b9625402802d94cd0fd71959b87a80f2b9c4d426e2e50000000000000011000000000000002003817246d751265f6a1a46fdf940918a9b07f490d354c8eb74b95ec55b724a7a00000000000000060000000000000001000000000000000000000000000000201e1c7edb3e17fda01f81dc087e722cb87fee8e1abe4ed118e51334732c546fbf0000000000000001000000000000000100000000000000202c5cee28f64782e66ac6834e8e7af7c5ed1daae9377b390c928b5dde9c70918a000000000000000100000000000000010000000000000020587b1d0d7ae4150be4e5acf3988386db46fbb63737fddcca5905eb7ad8b2fe6f0000000000000001000000000000000100000000000000203c10c603a48f27f2b37337f00efdf55ec8be361c1d99250b084b9eef8dadbd2600000000000000010000000000000000000000000000002053df6795528d73b87feeda729d99253a95b29978bc29c253a40bee596c43a5d7000000000000000100000000000000010000000000000020697d12fd2805d0d1e49a6cd41d31c56d8122552201c8b68a06acef4b1c56cb08000000000000000200000000000000110000000000000020f57ba31d0ef1922aafc64459663ae2da1c528be215fee9d4dd13ab726beff698000000000000000700000000000000010000000000000000000000000000002032d0d9e307e8ebb61ec375cbaf24a412cae8977ee91ff86fde0a6b9633766aab0000000000000001000000000000000100000000000000204751322b32975e658ad633c08578c5668763459e7684a693a119badc642c19ca0000000000000001000000000000000100000000000000209f1e3f78389a6c70f16756eff0df8211cbd06250cd386124a66248743cb1f43e000000000000000100000000000000010000000000000020f0777a1c3967896213380307c6a40a48f726024ca53abbe88cc9ccb3c6c57ad10000000000000001000000000000000000000000000000203d5d0f244c232325d8723d297c283d8d29932f8fe43fee62e295a463c53b7ff9000000000000000100000000000000010000000000000020ed7ebd63ef842c0804c0d1447fba31b56e79a154ae966ca9cf6f86aeadff9963000000000000000100000000000000010000000000000020261f9bb561ad563bd0f1e5fc873f26b9c22a7cb8a0853446a11bcd6c82ce0cb900000000000000510000000000000020f57ba31d0ef1922aafc64459663ae2da1c528be215fee9d4dd13ab726beff6980000000000000007000000000000000100000000000000000000000000000020cfeef7f47a845884ba92e9f487488327894d55014db910c5ba40dffa692c58530000000000000001000000000000000100000000000000202359e55ef41889edba8b8c4342038f08352a2f2f0315fcd7718268f83267337800000000000000010000000000000001000000000000002088b2432eb8341dd337bffc734f298e270a1c7b60cc3bb85aaa633b7a74fe607f000000000000000100000000000000010000000000000020118ab285c8f73c88dee1248f641ca0cb519c0ff1370b259ed464f6b44ec32875000000000000000100000000000000000000000000000020ecdbbf8690797643d06b55c19beca8fedb85e838916e16530830bf1d3d5a8d83000000000000000100000000000000010000000000000020a3fbd51b4c3e1b3d8413fcf7e028a60b1e8d0283b273d795ddde8a42377eb2840000000000000001000000000000000000000000000000204554d90173fb11d2545dff4e231cdf7343fca8559baeee5121c704eb180d4c731cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e000000000000002003817246d751265f6a1a46fdf940918a9b07f490d354c8eb74b95ec55b724a7a00000000000000020530ba5bf91aef20f7861bc93bbfbf7106e8e97579ff4e72c3ea362876acccfa21258bd73c487cbb48a5d6954a37d97b10f4b0e8a522c92041560fb50e1f7582000000000000000000000000000000204c0d2df7432ee601ab2340a62cd73e9024d4273e1667cf62e3ed9bb970da46ae0000000000000005000000000000000100000000000000010000000000000020c9a4afed0802bf1d2d8010ea1aec000a04a7fff5a542d7a4740ef0121025c930000000000000000100000000000000010000000000000020d81a19f191a868e765f6cbe849a214b62140c502bc594c797ac3ded72e28676b000000000000000100000000000000010000000000000020e5db2f9f8f262ee83002b4853391779b128e4b333520a6e9ffdc94b8b02067910000000000000001000000000000000100000000000000206999e907ab9cf7ba8df803acd54b8dfc0d99c4c0e85f5cb2cd3e30e794dbbc0d000000000000000100000000000000010000000000000020ef6805cf334410dd3af5d5302c4b3890deaa76df975e418f2f4991a7f697cd1a00000000000000020000000000000011000000000000002003817246d751265f6a1a46fdf940918a9b07f490d354c8eb74b95ec55b724a7a00000000000000060000000000000001000000000000000000000000000000201e1c7edb3e17fda01f81dc087e722cb87fee8e1abe4ed118e51334732c546fbf0000000000000001000000000000000100000000000000202c5cee28f64782e66ac6834e8e7af7c5ed1daae9377b390c928b5dde9c70918a000000000000000100000000000000010000000000000020587b1d0d7ae4150be4e5acf3988386db46fbb63737fddcca5905eb7ad8b2fe6f0000000000000001000000000000000100000000000000203c10c603a48f27f2b37337f00efdf55ec8be361c1d99250b084b9eef8dadbd2600000000000000010000000000000000000000000000002053df6795528d73b87feeda729d99253a95b29978bc29c253a40bee596c43a5d7000000000000000100000000000000010000000000000020697d12fd2805d0d1e49a6cd41d31c56d8122552201c8b68a06acef4b1c56cb080000000000000031000000000000002003817246d751265f6a1a46fdf940918a9b07f490d354c8eb74b95ec55b724a7a00000000000000060000000000000001000000000000000000000000000000202e1b8abe87bdd2d1b8e6bf151dfdd11b21f2f48f11a3f1dbeac7185caffdfba0000000000000000100000000000000010000000000000020578eeb8faad5375927a1a9b5a5eb1029ae012395ae36a8ff2aa777f8776b3d5f0000000000000001000000000000000100000000000000200cb790d5a63f2e3dde7eec9037bb521ec10a46af302cee94a105e5dbb676ce5e000000000000000100000000000000010000000000000020921f62b5478d95f9250cd0adb3823e84f4a6f2209b26ce04c629c0b893eded440000000000000001000000000000000000000000000000204442c967c3fd3ed977d5502c100a2c7f645374be9087920455ad399fd54e88c900000000000000010000000000000000000000000000002071ef95e516f6f98ba8943758e6fe15f1e3a94c9f2a3c6a7170d0d15af8bd53721cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e00000000000000204c0d2df7432ee601ab2340a62cd73e9024d4273e1667cf62e3ed9bb970da46ae00000000000000021cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e1cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e00000000000000000000000000000020ef6805cf334410dd3af5d5302c4b3890deaa76df975e418f2f4991a7f697cd1a0000000000000004000000000000000100000000000000010000000000000020c9a4afed0802bf1d2d8010ea1aec000a04a7fff5a542d7a4740ef0121025c930000000000000000100000000000000010000000000000020d81a19f191a868e765f6cbe849a214b62140c502bc594c797ac3ded72e28676b000000000000000100000000000000010000000000000020e5db2f9f8f262ee83002b4853391779b128e4b333520a6e9ffdc94b8b02067910000000000000001000000000000000100000000000000206999e907ab9cf7ba8df803acd54b8dfc0d99c4c0e85f5cb2cd3e30e794dbbc0d0000000000000002000000000000000000000000000000204c0d2df7432ee601ab2340a62cd73e9024d4273e1667cf62e3ed9bb970da46ae0000000000000005000000000000000100000000000000010000000000000020c9a4afed0802bf1d2d8010ea1aec000a04a7fff5a542d7a4740ef0121025c930000000000000000100000000000000010000000000000020d81a19f191a868e765f6cbe849a214b62140c502bc594c797ac3ded72e28676b000000000000000100000000000000010000000000000020e5db2f9f8f262ee83002b4853391779b128e4b333520a6e9ffdc94b8b02067910000000000000001000000000000000100000000000000206999e907ab9cf7ba8df803acd54b8dfc0d99c4c0e85f5cb2cd3e30e794dbbc0d000000000000000100000000000000010000000000000020ef6805cf334410dd3af5d5302c4b3890deaa76df975e418f2f4991a7f697cd1a000000000000000000000000000000204c0d2df7432ee601ab2340a62cd73e9024d4273e1667cf62e3ed9bb970da46ae0000000000000005000000000000000100000000000000010000000000000020c9a4afed0802bf1d2d8010ea1aec000a04a7fff5a542d7a4740ef0121025c930000000000000000100000000000000010000000000000020d81a19f191a868e765f6cbe849a214b62140c502bc594c797ac3ded72e28676b000000000000000100000000000000010000000000000020e5db2f9f8f262ee83002b4853391779b128e4b333520a6e9ffdc94b8b02067910000000000000001000000000000000100000000000000206999e907ab9cf7ba8df803acd54b8dfc0d99c4c0e85f5cb2cd3e30e794dbbc0d000000000000000100000000000000010000000000000020ef6805cf334410dd3af5d5302c4b3890deaa76df975e418f2f4991a7f697cd1a1cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e0000000000000020ef6805cf334410dd3af5d5302c4b3890deaa76df975e418f2f4991a7f697cd1a00000000000000021cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e1cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e000000000000000000000000000000206999e907ab9cf7ba8df803acd54b8dfc0d99c4c0e85f5cb2cd3e30e794dbbc0d0000000000000003000000000000000100000000000000010000000000000020c9a4afed0802bf1d2d8010ea1aec000a04a7fff5a542d7a4740ef0121025c930000000000000000100000000000000010000000000000020d81a19f191a868e765f6cbe849a214b62140c502bc594c797ac3ded72e28676b000000000000000100000000000000010000000000000020e5db2f9f8f262ee83002b4853391779b128e4b333520a6e9ffdc94b8b0206791000000000000000200000000000000000000000000000020ef6805cf334410dd3af5d5302c4b3890deaa76df975e418f2f4991a7f697cd1a0000000000000004000000000000000100000000000000010000000000000020c9a4afed0802bf1d2d8010ea1aec000a04a7fff5a542d7a4740ef0121025c930000000000000000100000000000000010000000000000020d81a19f191a868e765f6cbe849a214b62140c502bc594c797ac3ded72e28676b000000000000000100000000000000010000000000000020e5db2f9f8f262ee83002b4853391779b128e4b333520a6e9ffdc94b8b02067910000000000000001000000000000000100000000000000206999e907ab9cf7ba8df803acd54b8dfc0d99c4c0e85f5cb2cd3e30e794dbbc0d00000000000000000000000000000020ef6805cf334410dd3af5d5302c4b3890deaa76df975e418f2f4991a7f697cd1a0000000000000004000000000000000100000000000000010000000000000020c9a4afed0802bf1d2d8010ea1aec000a04a7fff5a542d7a4740ef0121025c930000000000000000100000000000000010000000000000020d81a19f191a868e765f6cbe849a214b62140c502bc594c797ac3ded72e28676b000000000000000100000000000000010000000000000020e5db2f9f8f262ee83002b4853391779b128e4b333520a6e9ffdc94b8b02067910000000000000001000000000000000100000000000000206999e907ab9cf7ba8df803acd54b8dfc0d99c4c0e85f5cb2cd3e30e794dbbc0d1cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e00000000000000206999e907ab9cf7ba8df803acd54b8dfc0d99c4c0e85f5cb2cd3e30e794dbbc0d00000000000000021cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e1cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e00000000000000000000000000000020e5db2f9f8f262ee83002b4853391779b128e4b333520a6e9ffdc94b8b02067910000000000000002000000000000000100000000000000010000000000000020c9a4afed0802bf1d2d8010ea1aec000a04a7fff5a542d7a4740ef0121025c930000000000000000100000000000000010000000000000020d81a19f191a868e765f6cbe849a214b62140c502bc594c797ac3ded72e28676b0000000000000002000000000000000000000000000000206999e907ab9cf7ba8df803acd54b8dfc0d99c4c0e85f5cb2cd3e30e794dbbc0d0000000000000003000000000000000100000000000000010000000000000020c9a4afed0802bf1d2d8010ea1aec000a04a7fff5a542d7a4740ef0121025c930000000000000000100000000000000010000000000000020d81a19f191a868e765f6cbe849a214b62140c502bc594c797ac3ded72e28676b000000000000000100000000000000010000000000000020e5db2f9f8f262ee83002b4853391779b128e4b333520a6e9ffdc94b8b0206791000000000000000000000000000000206999e907ab9cf7ba8df803acd54b8dfc0d99c4c0e85f5cb2cd3e30e794dbbc0d0000000000000003000000000000000100000000000000010000000000000020c9a4afed0802bf1d2d8010ea1aec000a04a7fff5a542d7a4740ef0121025c930000000000000000100000000000000010000000000000020d81a19f191a868e765f6cbe849a214b62140c502bc594c797ac3ded72e28676b000000000000000100000000000000010000000000000020e5db2f9f8f262ee83002b4853391779b128e4b333520a6e9ffdc94b8b02067911cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e0000000000000020e5db2f9f8f262ee83002b4853391779b128e4b333520a6e9ffdc94b8b020679100000000000000021cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e1cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e00000000000000000000000000000020d81a19f191a868e765f6cbe849a214b62140c502bc594c797ac3ded72e28676b0000000000000001000000000000000100000000000000010000000000000020c9a4afed0802bf1d2d8010ea1aec000a04a7fff5a542d7a4740ef0121025c930000000000000000200000000000000000000000000000020e5db2f9f8f262ee83002b4853391779b128e4b333520a6e9ffdc94b8b02067910000000000000002000000000000000100000000000000010000000000000020c9a4afed0802bf1d2d8010ea1aec000a04a7fff5a542d7a4740ef0121025c930000000000000000100000000000000010000000000000020d81a19f191a868e765f6cbe849a214b62140c502bc594c797ac3ded72e28676b00000000000000000000000000000020e5db2f9f8f262ee83002b4853391779b128e4b333520a6e9ffdc94b8b02067910000000000000002000000000000000100000000000000010000000000000020c9a4afed0802bf1d2d8010ea1aec000a04a7fff5a542d7a4740ef0121025c930000000000000000100000000000000010000000000000020d81a19f191a868e765f6cbe849a214b62140c502bc594c797ac3ded72e28676b1cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e0000000000000020d81a19f191a868e765f6cbe849a214b62140c502bc594c797ac3ded72e28676b00000000000000021cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e1cf63458490a37e1bab764d4466495999eac905aa081510a8e0cdfd387aed17e00000000000000000000000000000020a032f2e7ff7f0000d93a5b0000000000eda00c13d58f80b4f8ffffffffffffff0000000000000000000000000000000200000000000000000000000000000020d81a19f191a868e765f6cbe849a214b62140c502bc594c797ac3ded72e28676b0000000000000001000000000000000100000000000000010000000000000020c9a4afed0802bf1d2d8010ea1aec000a04a7fff5a542d7a4740ef0121025c93000000000000000000000000000000020d81a19f191a868e765f6cbe849a214b62140c502bc594c797ac3ded72e28676b0000000000000001000000000000000100000000000000010000000000000020c9a4afed0802bf1d2d8010ea1aec000a04a7fff5a542d7a4740ef0121025c930";
        bytes memory init_blob = hex"00010203040506070809";
        transcript_updated.transcript_data memory tr_state;
        transcript_updated.init_transcript(tr_state, init_blob);
        fri_verifier_adapted.params_type memory params;
        params.modulus = modulus;
        params.r = 9;
        params.max_degree = 511;
        uint256[] memory D_omegas = new uint256[](params.r);
        D_omegas[0] = 6837567842312086091520287814181175430087169027974246751610506942214842701774;
        D_omegas[1] = 3478517300119284901893091970156912948790432420133812234316178878452092729974;
        D_omegas[2] = 10359452186428527605436343203440067497552205259388878191021578220384701716497;
        D_omegas[3] = 9088801421649573101014283686030284801466796108869023335878462724291607593530;
        D_omegas[4] = 4419234939496763621076330863786513495701855246241724391626358375488475697872;
        D_omegas[5] = 14940766826517323942636479241147756311199852622225275649687664389641784935947;
        D_omegas[6] = 19540430494807482326159819597004422086093766032135589407132600596362845576832;
        D_omegas[7] = 21888242871839275217838484774961031246007050428528088939761107053157389710902;
        D_omegas[8] = 21888242871839275222246405745257275088548364400416034343698204186575808495616;
        params.D_omegas = D_omegas;
        uint256[] memory q = new uint256[](3);
        q[0] = 0;
        q[1] = 0;
        q[2] = 1;
        params.q = q;
        uint256[] memory U = new uint256[](1);
        U[0] = 0;
        uint256[] memory V = new uint256[](1);
        V[0] = 1;
        params.U = U;
        params.V = V;
        (fri_verifier_adapted.proof_type memory proof, uint256 proof_size) = fri_verifier_adapted.parse_proof_be(raw_proof, 0);
        Assert.equal(raw_proof.length, proof_size, "Proof length is not correct");
        bool result = fri_verifier_adapted.verifyProof(proof, tr_state, params);
        Assert.equal(true, result, "Proof is not correct");
    }
}
