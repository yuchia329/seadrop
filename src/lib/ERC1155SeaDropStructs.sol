// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { AllowListData, CreatorPayout } from "./SeaDropStructs.sol";

/**
 * @notice A struct defining public drop data.
 *         Designed to fit efficiently in two storage slots.
 *
 * @param startPrice               The start price per token. (Up to 1.2m
 *                                 of native token, e.g. ETH, MATIC)
 * @param endPrice                 The end price per token. If this differs
 *                                 from startPrice, the current price will
 *                                 be calculated based on the current time.
 * @param startTime                The start time, ensure this is not zero.
 * @param endTime                  The end time, ensure this is not zero.
 * @param paymentToken             The payment token address. Null for
 *                                 native token.
 * @param fromTokenId              The start token id for the stage.
 * @param toTokenId                The end token id for the stage.
 * @param maxTotalMintableByWallet Maximum total number of mints a user is
 *                                 allowed. (The limit for this field is
 *                                 2^16 - 1)
 * @param maxTotalMintableByWalletPerToken Maximum total number of mints a user
 *                                 is allowed for the token id. (The limit for
 *                                 this field is 2^16 - 1)
 * @param feeBps                   Fee out of 10_000 basis points to be
 *                                 collected.
 * @param restrictFeeRecipients    If false, allow any fee recipient;
 *                                 if true, check fee recipient is allowed.
 */
struct PublicDrop {
    uint80 startPrice; // 80/512 bits
    uint80 endPrice; // 160/512 bits
    uint48 startTime; // 368/512 bits
    uint48 endTime; // 416/512 bits
    address paymentToken; // 320/512 bits
    uint24 fromTokenId;
    uint24 toTokenId;
    uint16 maxTotalMintableByWallet; // 432/512 bits
    uint16 maxTotalMintableByWalletPerToken; // 432/512 bits
    uint16 feeBps; // 448/512 bits
    bool restrictFeeRecipients; // 456/512 bits
}

/**
 * @notice A struct defining token gated drop stage data.
 *         Designed to fit efficiently in two storage slots.
 *
 * @param startPrice               The start price per token. (Up to 1.2m
 *                                 of native token, e.g. ETH, MATIC)
 * @param endPrice                 The end price per token. If this differs
 *                                 from startPrice, the current price will
 *                                 be calculated based on the current time.
 * @param startTime                The start time, ensure this is not zero.
 * @param endTime                  The end time, ensure this is not zero.
 * @param paymentToken             The payment token for the mint. Null for
 *                                 native token.
 * @param fromTokenId              The start token id for the stage.
 * @param toTokenId                The end token id for the stage.
 * @param maxTotalMintableByWallet Maximum total number of mints a user is
 *                                 allowed. (The limit for this field is
 *                                 2^16 - 1)
 * @param maxTotalMintableByWalletPerToken Maximum total number of mints a user
 *                                 is allowed for the token id. (The limit for
 *                                 this field is 2^16 - 1)
 * @param maxTokenSupplyForStage   The limit of token supply this stage can
 *                                 mint within. (The limit for this field is
 *                                 2^16 - 1)
 * @param dropStageIndex           The drop stage index to emit with the event
 *                                 for analytical purposes. This should be
 *                                 non-zero since the public mint emits
 *                                 with index zero.
 * @param feeBps                   Fee out of 10_000 basis points to be
 *                                 collected.
 * @param restrictFeeRecipients    If false, allow any fee recipient;
 *                                 if true, check fee recipient is allowed.
 */
struct TokenGatedDropStage {
    uint80 startPrice; // 80/512 bits
    uint80 endPrice; // 160/512 bits
    uint40 startTime; // 392/512 bits
    uint40 endtime; // 432/512 bits
    address paymentToken; // 320/512 bits
    uint24 fromTokenId;
    uint24 toTokenId;
    uint16 maxMintablePerRedeemedToken; // 336/512 bits
    uint16 maxTotalMintableByWallet; // 352/512 bits
    uint16 maxTotalMintableByWalletPerToken; // 352/512 bits
    uint32 maxTokenSupplyForStage; // 482/512 bits
    uint8 dropStageIndex; // non-zero. 450/512 bits
    uint16 feeBps; // 498/512 bits
    bool restrictFeeRecipients; // 506/512 bits
}

/**
 * @notice A struct defining mint params for an allow list.
 *         An allow list leaf will be composed of `msg.sender` and
 *         the following params.
 *
 *         Note: Since feeBps is encoded in the leaf, backend should ensure
 *         that feeBps is acceptable before generating a proof.
 *
 * @param startPrice               The start price per token. (Up to 1.2m
 *                                 of native token, e.g. ETH, MATIC)
 * @param endPrice                 The end price per token. If this differs
 *                                 from startPrice, the current price will
 *                                 be calculated based on the current time.
 * @param startTime                The start time, ensure this is not zero.
 * @param endTime                  The end time, ensure this is not zero.
 * @param paymentToken             The payment token for the mint. Null for
 *                                 native token.
 * @param fromTokenId              The start token id for the stage.
 * @param toTokenId                The end token id for the stage.
 * @param maxTotalMintableByWallet Maximum total number of mints a user is
 *                                 allowed.
 * @param maxTotalMintableByWalletPerToken Maximum total number of mints a user
 *                                 is allowed for the token id.
 * @param maxTokenSupplyForStage   The limit of token supply this stage can
 *                                 mint within.
 * @param dropStageIndex           The drop stage index to emit with the event
 *                                 for analytical purposes. This should be
 *                                 non-zero since the public mint emits with
 *                                 index zero.
 * @param feeBps                   Fee out of 10_000 basis points to be
 *                                 collected.
 * @param restrictFeeRecipients    If false, allow any fee recipient;
 *                                 if true, check fee recipient is allowed.
 */
struct MintParams {
    uint256 startPrice;
    uint256 endPrice;
    uint256 startTime;
    uint256 endTime;
    address paymentToken;
    uint256 fromTokenId;
    uint256 toTokenId;
    uint256 maxTotalMintableByWallet;
    uint256 maxTotalMintableByWalletPerToken;
    uint256 maxTokenSupplyForStage;
    uint256 dropStageIndex; // non-zero
    uint256 feeBps;
    bool restrictFeeRecipients;
}

/**
 * @notice A struct defining minimum and maximum parameters to validate for
 *         signed mints, to minimize negative effects of a compromised signer.
 *
 * @param minMintPrice                The minimum mint price allowed.
 * @param paymentToken                The required paymentToken.
 * @param fromTokenId                 The start token id for the stage.
 * @param toTokenId                   The end token id for the stage.
 * @param maxMaxTotalMintableByWallet The maximum total number of mints allowed
 *                                    by a wallet.
 * @param maxMaxTotalMintableByWalletPerToken Maximum total number of mints a
 *                                    user is allowed for the token id.
 * @param minStartTime                The minimum start time allowed.
 * @param maxEndTime                  The maximum end time allowed.
 * @param maxMaxTokenSupplyForStage   The maximum token supply allowed.
 * @param minFeeBps                   The minimum fee allowed.
 * @param maxFeeBps                   The maximum fee allowed.
 */
struct SignedMintValidationParams {
    uint80 minMintPrice; // 80/512 bits
    address paymentToken; // 240/512 bits
    uint24 fromTokenId;
    uint24 toTokenId;
    uint24 maxMaxTotalMintableByWallet; // 264/512 bits
    uint24 maxMaxTotalMintableByWalletPerToken;
    uint40 minStartTime; // 304/512 bits
    uint40 maxEndTime; // 344/512 bits
    uint40 maxMaxTokenSupplyForStage; // 384/512 bits
    uint16 minFeeBps; // 400/512 bits
    uint16 maxFeeBps; // 416/512 bits
}

/**
 * @notice A struct to configure multiple contract options in one transaction.
 */
struct MultiConfigureStruct {
    uint256[] maxSupplyTokenIds;
    uint256[] maxSupplyAmounts;
    string baseURI;
    string contractURI;
    PublicDrop[] publicDrops;
    uint256[] publicDropsIndexes;
    string dropURI;
    AllowListData allowListData;
    CreatorPayout[] creatorPayouts;
    bytes32 provenanceHash;
    address[] allowedFeeRecipients;
    address[] disallowedFeeRecipients;
    address[] allowedPayers;
    address[] disallowedPayers;
    // Token-gated
    address[] tokenGatedAllowedNftTokens;
    TokenGatedDropStage[] tokenGatedDropStages;
    address[] disallowedTokenGatedAllowedNftTokens;
    // Server-signed
    address[] signers;
    SignedMintValidationParams[] signedMintValidationParams;
    address[] disallowedSigners;
    // ERC-2981
    address royaltyReceiver;
    uint96 royaltyBps;
}