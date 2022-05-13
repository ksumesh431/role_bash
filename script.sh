#!/bin/bash



# FUNCTION TO GET "ROLE" BY USING EC2 INSTANCES WITH CUSTOM TAG
get_instances_with_tag(){
    
    res=$(aws ec2 describe-instances --region us-east-1 --filters Name=tag:$1,Values=$2 --profile $3)
    
    roleARN=$(echo $res \
    | python3 -c "import sys, json; print(json.load(sys.stdin)['Reservations'][0]['Instances'][0]['IamInstanceProfile']['Arn'])")
    
    # echo $iamProfile
    
    roleName=${roleARN:43}
    echo Rolename is $roleName
    echo Role ARN is $roleARN
    
}
####### here key is tagtest and value is searchrolebythis

# get_instances_with_tag "tagtest" "searchrolebythis" 000699977340










# FUNCTION TO "ATTACH POLICY" TO A ROLE
attach_policy_to_role(){
    
    aws iam put-role-policy --role-name $1 --policy-name $2 --policy-document file://$3 --profile $4
    
}
# attach_policy_to_role $roleName  demopolicy "policy.json" 000699977340

















# ADDS A CUSTOM ARN TO TRUST RELATIONSHIP OF THE ROLE
add_arn_in_trustrelationship(){
    
    part1='{ "Version": "2012-10-17", "Statement": [ { "Effect": "Deny", "Principal": { "Service": "ec2.amazonaws.com"'
    
    part2=',"AWS":["'
    
    randomARN=$1
    
    part3='"]'
    
    part4='}, "Action": "sts:AssumeRole" } ] }'
    
    finalPolicy=$part1$part2$randomARN$part3$part4
    echo $finalPolicy | jq "." > trustRelAcc1.json
    
    aws iam update-assume-role-policy --role-name $2 --policy-document file://trustRelAcc1.json --profile $3
    
    
    #To check if trust rel policy is added or not to role
    roleDetails=$(aws iam get-role --role-name $2 --profile $3)
    trustRelJSON=$(echo $roleDetails | jq ".Role.AssumeRolePolicyDocument")
    echo $trustRelJSON
    
}

inputarn="arn:aws:iam::000699977340:role/AmazonSSMRoleForInstancesQuickSetup"
# add_arn_in_trustrelationship $inputarn demoskp 000699977340

































