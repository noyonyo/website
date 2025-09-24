# Website


#### Unable to start server due to wrong esbuild (@exbuild/darwin-x64)

```shell
source $(brew --prefix nvm)/nvm.sh
nvm
```
#### Running Vite throws an exception on access

##### Solution: run

```shell
sudo chmod -R 777 ./node_modules/.cache/.vite
```

#### Password prompt removal

```shell
echo "$USER ALL=NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
```