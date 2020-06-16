# ~Assume Role Action~

**DEPRECATED**! Use [the official one](https://github.com/aws-actions/configure-aws-credentials) (via [third-party-actions](https://github.com/Brightspace/third-party-actions) for D2Lers)

This action uses [sts:AssumeRole](https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html) to get temporary AWS IAM tokens, installing them as environment variables.

You want this when your repo has secrets for a role that can assume other roles, possibly in different AWS accounts.
This could be for a prod/dev account split, or just a larger repo which does a bunch of different things.

## Usage

```yaml
    steps:
    
      # ...
    
      - name: Assume role
        uses: Brightspace/assume-role-action@master
        with:
          role-arn: "arn:aws:iam::1234567890:role/my-role"
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_SESSION_TOKEN: ${{ secrets.AWS_SESSION_TOKEN }}
      
      - name: Hello, AWS!
        run: aws ec2 describe-instances # runs with the permissions from arn:aws:iam::1234567890:role/my-role
        env:
          AWS_DEFAULT_REGION: ca-central-1

      # ...
```

For all steps after the "Assume role" step the environment variables `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_SESSION_TOKEN` will be populated with credentials scoped to the `my-role` IAM role.

The `AWS_SESSION_TOKEN` env in the "Assume role" step is optional--you'll know if you need it.
At D2L we store temporary tokens in our GitHub secrets via an internal automation.

## Why environment variables, and not the credentials file?

We've found the the environment variables work consistently with tools and SDKs, but support for the credentials file (particularly with assume role/temporary credentials) is more spotty.

We also run self-hosted GitHub runners and don't allow non-container-based jobs to write to `~/.aws/credentials`.
