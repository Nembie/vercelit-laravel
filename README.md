# Vercelize Laravel

![Vercelize Laravel](https://github.com/Nembie/vercelize-laravel/assets/47114030/40354912-68d9-457f-ab15-e3967f8dcfd7)


This Bash script automates the setup process for deploying a Laravel project on Vercel. It allows you to configure essential environment variables, create required files and directories, and generate a Vercel configuration.

## 🚀 Usage

```bash
./vercelize-laravel.sh [-h] [-r]
```

## ⚙️ Installation

Download the script to your Laravel project directory.

Give execute permissions to the script:
```bash
chmod +x vercelize-laravel.sh
```

Run the script:
```bash
./vercelize-laravel.sh
```

## 🧰 Options

#### Reinstall Option

You can use the -r or --reinstall option to reinstall the setup, overwriting necessary files. This is useful if you need to reset or update your configuration.

```bash
./vercelize-laravel.sh -r
```

## 🔧 Enviroment variables

The script prompts you to enter values for the following environment variables:

```
APP_URL: The URL for your Laravel application (default: https://yourproductionurl.com).
APP_ENV: The environment for your application (default: production).
APP_DEBUG: Whether debugging is enabled (default: true).
```

This script defaults to using the .env.vercel file if present; otherwise, it will use the .env file.

## 🤝 Contribution
If you find any issues or have suggestions for improvements, feel free to open a pull request or issue. Your contribution is highly appreciated.

## 📝 License

This package is open-sourced software licensed under the [MIT license](https://github.com/Nembie/vercelize-laravel/blob/main/LICENSE).
