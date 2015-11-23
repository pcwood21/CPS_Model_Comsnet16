function [ ownership, toptier ] = cnexp2_owenership_model( numOwners,numAssets )
%CNEXP2_OWENERSHIP_MODEL Summary of this function goes here
%   Detailed explanation goes here

rng(1);

assigned_ownership=randperm(numAssets);

ownership=zeros(numOwners,numAssets/numOwners);
k=1;
for i=1:numOwners
    ownership(i,:)=assigned_ownership(k:k+numAssets/numOwners-1);
    k=k+numAssets/numOwners;
end

assigned_toptier=randperm(numOwners);


numTopTier=4;
toptier=zeros(numTopTier,numOwners/numTopTier);
k=1;
for i=1:numTopTier
    toptier(i,:)=assigned_toptier(k:k+numOwners/numTopTier-1);
    k=k+numOwners/numTopTier;
end

rng('shuffle');

end

