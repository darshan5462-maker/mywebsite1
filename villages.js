let villageDatabase = [];

async function loadVillages() {

  try {

    const response =
      await fetch("Karnataka_Villages.csv");

    const csvText =
      await response.text();

    const rows =
      csvText.split(/\r?\n/);

    rows.slice(1).forEach(row => {

      const cols = row.split(",");

      if(cols.length < 12) return;

      villageDatabase.push({

        district: cols[3]?.trim(),

        taluk: cols[5]?.trim(),

        village: cols[7]?.trim(),

        panchayat: cols[11]?.trim()

      });

    });

    console.log(
      "Villages Loaded:",
      villageDatabase.length
    );

    console.log(
      "Sample:",
      villageDatabase[0]
    );

  } catch(err) {

    console.error(err);

  }

}

loadVillages();
