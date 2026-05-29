export default {
  content: [
    "./resources/**/*.blade.php",
    "./resources/**/*.js",
    "./resources/**/*.vue",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Outfit', 'Inter', 'sans-serif'],
      },
      colors: {
        brand: {
          50: '#f5f7fa',
          100: '#eaeef4',
          200: '#d5dde9',
          300: '#b2c3d8',
          400: '#8aa3c3',
          500: '#6784ac',
          600: '#526b91',
          700: '#435677',
          800: '#3a4a64',
          900: '#333f54',
          950: '#222937',
        },
      },
    },
  },
  plugins: [],
}
