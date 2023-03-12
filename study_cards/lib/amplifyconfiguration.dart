const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "studyCards": {
                    "endpointType": "REST",
                    "endpoint": "https://6tgd61quje.execute-api.sa-east-1.amazonaws.com/dev",
                    "region": "sa-east-1",
                    "authorizationType": "AWS_IAM"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "sa-east-1:5859a727-b85a-4083-8ec1-7e3c20a581ad",
                            "Region": "sa-east-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "sa-east-1_z9ELjeQ85",
                        "AppClientId": "55ccnololktvf19l4ln52tpcj7",
                        "Region": "sa-east-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [
                            "SMS"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "signupAttributes": [
                            "EMAIL"
                        ],
                        "socialProviders": [],
                        "usernameAttributes": [],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "studycardsb957f462d51d44c2810c1075577cabfe221503-dev",
                        "Region": "sa-east-1"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "studycardsb957f462d51d44c2810c1075577cabfe221503-dev",
                "region": "sa-east-1",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';