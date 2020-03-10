namespace :import do
  desc 'Import some csv file'
  task csv: :environment do
    file_path = ENV['file_path']

    status_id = Status.where(name: 'approved').first.id

    CSV.foreach(file_path, headers: first_row) do |row|
      PointOfSale.create!(
        name: row[0],
        address: row[1],
        posTypeId: row[2],
        productCategoryIds: row[3].split(',').map(&:to_i),
        description: row[5],
        website: row[6],
        mail: row[7],
        phone: row[8],
        cell_phone: row[9],
        marketStalls: [],
        status_id: status_id,
        openingTimes: opening_times(row[4])
      )
    end
  end

  def opening_times(data)
    data.split(',').map do |day|
      { day: day.split('=')[0].to_i,
        from: day.split('=')[1].split('-')[0],
        to: day.split('=')[1].split('-')[1] }
    end
  end
end
